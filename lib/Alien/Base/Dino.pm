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

my %dl_path = (
  darwin  => 'DYLD_LIBRARY_PATH',
  MSWin32 => 'PATH',
);

require Env;
my @dl_path;
my $dl_path = $dl_path{$^O} || 'LD_LIBRARY_PATH';
tie @dl_path, 'Env::Array', $dl_path;

=head1 METHODS

=head2 xs_load

 $alien->xs_load($package, $version);
 $alien->xs_load($package, $version, @other_dino_aliens);

=cut

sub xs_load
{
  my($self, $package, $version, @rest) = @_;

  local $ENV{$dl_path} = $ENV{$dl_path};

  if($self->install_type eq 'share')
  {
    require Path::Tiny;
    foreach my $alien ($self, @rest)
    {
      if($alien->can('runtime_prop'))
      {
        my $root = $alien->dist_dir;
        my $prop = $alien->runtime_prop;
        if(exists $prop->{dino_path} && ref($prop->{dino_path}) eq 'ARRAY')
        {
          my @paths = map { Path::Tiny->new($_)->absolute($root)->stringify } @{ $prop->{dino_path} };
          unshift @dl_path, @paths;
        }
      }
    }
  }

  require XSLoader;
  XSLoader::load($package, $version);
}

1;
