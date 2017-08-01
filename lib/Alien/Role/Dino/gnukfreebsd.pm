package Alien::Role::Dino::gnukfreebsd;

use strict;
use warnings;
use 5.008001;
use Role::Tiny;

requires 'libs';
requires 'rpath';

around libs => sub {
  my($orig, $self) = @_;
  join(' ', (map { "-Wl,-rpath,$_" } $self->rpath), $orig->($self));
};

1;

