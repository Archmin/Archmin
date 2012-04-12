package Archmin;
use Mojo::Base 'Mojolicious';
use Digest::SHA 'sha256_hex';
use Digest::MD5 'md5_hex';

# This method will run once at server start
sub startup {
  my $self = shift;
  # Documentation browser under "/perldoc"
  $self->plugin('PODRenderer');


  # Configuration parser
  my $config = $self->{config} = $self->plugin('yaml_config', {
            file      => 'conf/config.yaml',
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

        if ($users->{$uid})
        {
            $users->{$uid}->{username} = $uid;
            return $users->{$uid};
        }

        return;
    },
    validate_user   => sub {
        my ($self, $username, $password, $extradata) = @_;

        my $users = $self->app->{config}->{users};

        return $username if $users->{$username} && sha256_hex($password) eq 
            $users->{$username}->{password};

        return;
    },
    current_user_fn => 'user',
  });

  # Gravatar helper
  $self->helper(gravatar_for => sub {
     my ($self, $email, $size) = @_;
     return '<img src="http://www.gravatar.com/avatar/' . 
        md5_hex(lc($email)) . '?s=' . $size . '&d=retro" alt="gravatar" style="margin-top: -5px;">';
  });
  
  # Router
  my $r = $self->routes;
  # Set route namespace to Archmin::Controller
  $r->namespace('Archmin::Controller');

  $r->route('/login')->via('GET')->to('auth#login')->name('auth_login');
  $r->route('/login')->via('POST')->to('auth#create')->name('auth_create');

  # Require authentication
  $r->route('/logout')->over(authenticated => 1)->to('auth#delete')->name('auth_delete');
  $r->route('/')->over(authenticated => 1)->to('dashboard#index')->name('dashboard');

  # All else fails, fall back to auth
  $r->route('/')->to('auth_login');
}

1;
