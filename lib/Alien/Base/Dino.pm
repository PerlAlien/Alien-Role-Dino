package Alien::Base::Dino;

use strict;
use warnings;
use 5.008001;
use base qw( Alien::Base );

# ABSTRACT: Experimental support for dynamic share Alien install
# VERSION

sub import
{
  # We do NOT support the legacy Alien::Base interface for loading
  # DLLs.
}

sub xs_load
{
  my($module, $version, @rest) = @_;
}

1;
