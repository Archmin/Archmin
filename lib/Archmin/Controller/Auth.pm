package Archmin::Controller::Auth;
use Mojo::Base 'Mojolicious::Controller';


sub login {
  my $self = shift;
  $self->render();
}

sub create {
	my $self = shift;
	my $post = $self->req->body_params;
	if ($self->authenticate($post->param('username'), $post->param('password'), {}))
	{
		push @{ $self->session->{success_messages} }, 'Welcome back :)';
		$self->redirect_to('dashboard');
	} else {
		push @{ $self->session->{login_error} }, 
			'We couldn\'t validate your account :(';
		$self->redirect_to('auth_create');
	}
}

sub delete {
	my $self = shift;

	$self->redirect_to('auth_create') if $self->logout; 
}

1;
