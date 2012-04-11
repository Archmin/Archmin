package Archmin::Controller::Dashboard;
use Mojo::Base 'Mojolicious::Controller';

sub index {
  my $self = shift;

  $self->render(
    message => 'Welcome to Archmin!');
}

1;
