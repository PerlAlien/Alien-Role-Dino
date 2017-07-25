package Alien::Base::Dino::gnukfreebsd;

use strict;
use warnings;
use 5.008001;

package Alien::Base::Dino;

sub libs
{
  my($self) = @_;
  join(' ', (map { "-Wl,-rpath,$_" } $self->rpath), $self->SUPER::libs);
}

1;
