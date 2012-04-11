package Archmin;
use Mojo::Base 'Mojolicious';
use Mojo::Util 'hmac_md5_sum';

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

  # Authentication 
  $self->plugin('Authentication', {
    autoload_user   => 1,
    session_key     => 'Archmin',
    load_user       => sub {
        my ($self, $uid) = @_;

        my $users = $self->app->{config}->{users};

        return $users->{$uid} if $users->{$uid};

        return;
    },
    validate_user   => sub {
        my ($self, $username, $password, $extradata) = @_;

        my $users = $self->app->{config}->{users};

        return $username if $users->{$username} && hmac_md5_sum($password) eq $users->{$username};

        return;
    },
    current_user_fn => 'user',
  });
  
  # Router
  my $r = $self->routes;
<<<<<<< HEAD

  $r->route('/login')->via('GET')->to('auth#login');
  $r->route('/login')->via('POST')->to('auth#create');

  # Require authentication
  $r->route('/')->over(authenticated => 1)->to('dashboard#index');

  # All else fails, fall back to auth
  $r->route('/')->to('auth#login');


=======
  # Set route namespace to Archmin::Controller
  $r->namespace('Archmin::Controller');
  # TODO: Rename example controller.
  # Normal route to controller
  $r->route('/')->to('example#welcome')->name('home');
  # Setup bridge for login.
  my $rl = $r->bridge('/login')->to('auth#index');
  $rl->route->via('get')->to('auth#index')->name('auth_login_form');
  $rl->route->via('post')->to('auth#check')->name('auth_login_check');
>>>>>>> e0a6de9349735edfbfbfc529e5369c342558d499
}

1;
