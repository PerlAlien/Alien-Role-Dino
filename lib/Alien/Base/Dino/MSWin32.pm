package Alien::Base::Dino::MSWin32;

use strict;
use warnings;
use 5.008001;
use Env qw( @PATH );

sub Alien::Base::Dino::_xs_load_wrapper
{
  my($self, $code, @rest) = @_;
  local $ENV{PATH} = $ENV{PATH};
  unshift @PATH, $self->rpath(@rest);
  $code->();
}

1;
