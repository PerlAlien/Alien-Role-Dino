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

=head1 BASE CLASS

This class is a subclass of L<Alien::Base> and as such, in inherits all
of its methods and properties.

=head1 METHODS

=head2 xs_load

 $alien->xs_load($package, $version);
 $alien->xs_load($package, $version, @other_dino_aliens);

=cut

sub xs_load
{
  my($self, $package, $version, @rest) = @_;

  my $load = sub {
    require XSLoader;
    XSLoader::load($package, $version);
  };

  if($self->can('_xs_load_wrapper'))
  {
    $self->_xs_load_wrapper($load, @rest);
  }
  else
  {
    $load->();
  }
}

=head2 rpath

 my @dirs = $alien->rpath;

Returns the list of directories that have non-system dynamic libraries
in them.  On some systems this is needed at compile time, on others
it is needed at run time.

=cut

sub rpath
{
  my($self, @other) = @_;
  
  my @dir;
  
  foreach my $alien ($self, @other)
  {
    if($alien->can('runtime_prop') && defined $alien->runtime_prop->{rpath})
    {
      require Path::Tiny;
      foreach my $rpath (map { Path::Tiny->new($_)->absolute($alien->dist_dir)->stringify } @{ $alien->runtime_prop->{rpath} })
      {
        push @dir, $rpath;
      }
    }
  }
  
  @dir;
}

=head2 libs

 my $libs = $alien->libs;

On some platforms, this subclass overrides the behavior of the C<libs> method.

=cut

require "Alien/Base/Dino/$^O.pm";

1;
