use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
  VERSION   => '0.01',
  PREREQ_PM => {
    'Mojolicious'                         => '2.80'
    'YAML::XS'                            => '0',
    'Mojolicious::Plugin::Authentication' => '0',
    'Mojolicious::Plugin::YamlConfig'     => '0',
  },
  test      => {TESTS => 't/*.t'}
);
