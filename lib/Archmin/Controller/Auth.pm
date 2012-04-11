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
		# @TODO: Flash message for success.
		$self->redirect_to('/');
	} else {
		# @TODO: Flash message for failure.
		$self->redirect_to('/login');
	}
}

1;
