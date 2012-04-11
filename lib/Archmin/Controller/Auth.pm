package Archmin::Controller::Auth;
use Mojo::Base 'Mojolicious::Controller';

# We need to setup form validation too.

# Display login.
sub index {
  my $self = shift;

  # Render template "auth/index.html.ep" with message
  $self->render( message => 'Welcome to the Mojolicious real-time web framework!');

}

# Check a login.
sub check {
  my $self = shift;
  my $user = $self->param('username');
  my $pass = $self->param('password');
  # TODO: Check login.
}

1;
