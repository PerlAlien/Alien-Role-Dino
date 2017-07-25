package Alien::Base::Dino::linux;

use strict;
use warnings;
use 5.008001;

package Alien::Base::Dino;

sub libs
{
  my($self) = @_;
  
  my $libs = $self->SUPER::libs;

  if($self->runtime_prop->{rpath})
  {
    my $dist_dir = $self->dist_dir;
    require Path::Tiny;
    $libs = join(' ', (
      map { "-Wl,-rpath,$_" }
      map { Path::Tiny->new($_)->absolute($dist_dir) }
      @{ $self->runtime_prop->{rpath} }
    ), $libs);
  }

  $libs;
}

1;
