package Archmin;
use Mojo::Base 'Mojolicious';

# This method will run once at server start
sub startup {
  my $self = shift;
  # Documentation browser under "/perldoc"
  $self->plugin('PODRenderer');
  # Configuration parser
  my $config = $self->{config} = $self->plugin('yaml_config', {
            file      => 'etc/config.yaml',
            stash_key => 'config',
            class     => 'YAML::XS'
  });
  print "Please read the configuration file and try again.\n" and exit if $config->{die};
  # Session settings.
  $self->secret($config->{session}->{secret});
  # Router
  my $r = $self->routes;
  # Set route namespace to Archmin::Controller
  $r->namespace('Archmin::Controller');
  # TODO: Rename example controller.
  # Normal route to controller
  $r->route('/')->to('example#welcome')->name('home');
  # Setup bridge for login.
  my $rl = $r->bridge('/login')->to('auth#index');
  $rl->route->via('get')->to('auth#index')->name('auth_login_form');
  $rl->route->via('post')->to('auth#check')->name('auth_login_check');
}

1;
