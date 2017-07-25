package Alien::Base::Dino::cygwin;

use strict;
use warnings;
use 5.008001;
use Env qw( @PATH );

sub Alien::Base::Dino::_xs_load_wrapper
{
  my($self, $code, @rest) = @_;

  local $ENV{PATH} = $ENV{PATH};

  foreach my $alien ($self, @rest)
  {
    if($alien->can('runtime_prop') && defined $alien->runtime_prop->{rpath})
    {
      require Path::Tiny;
      foreach my $rpath (map { Path::Tiny->new($_)->absolute($alien->dist_dir) } @{ $alien->runtime_prop->{rpath} })
      {
        unshift @PATH, $rpath;
      }
    }
  }

  $DB::single = 1;
  $code->();
}

1;
