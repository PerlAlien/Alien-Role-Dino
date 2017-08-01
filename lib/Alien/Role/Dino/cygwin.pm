package Alien::Role::Dino::cygwin;

use strict;
use warnings;
use 5.008001;
use Role::Tiny;
use Env qw( @PATH );

requires 'xs_load';
requires 'rpath';

around xs_load => sub {
  my($orig, $self, $package, $version, @rest) = @_;
  local $ENV{PATH} = $ENV{PATH};
  unshift @PATH, $self->rpath(@rest);
  $orig->($self, $package, $version, @rest);
};

1;

