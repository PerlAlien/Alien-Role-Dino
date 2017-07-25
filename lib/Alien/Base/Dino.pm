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

=head1 METHODS

=head2 xs_load

 $alien->xs_load($package, $version);
 $alien->xs_load($package, $version, @other_dino_aliens);

=cut

sub xs_load
{
  my($self, $package, $version, @rest) = @_;
  require XSLoader;
  XSLoader::load($package, $version);
}

eval { require "Alien/Base/Dino/$^O.pm" };

1;
