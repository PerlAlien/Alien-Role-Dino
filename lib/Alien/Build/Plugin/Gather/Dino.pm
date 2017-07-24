package Alien::Build::Plugin::Gather::Dino;

use strict;
use warnings;
use 5.008001;
use Alien::Build::Plugin;
use FFI::CheckLib qw( find_lib );
use Path::Tiny qw( path );

# ABSTRACT: Experimental support for dynamic share Alien install
# VERSION

sub init
{
  my($self, $meta) = @_;
  
  $meta->after_hook(
    gather_share => sub {
      my($build) = @_;
      
      foreach my $path (map { path('.')->absolute->child($_) } qw( bin lib dynamic ))
      {
        next unless -d $path;
        if(find_lib(lib => '*', libpath => $path->stringify, systempath => []))
        {
          push @{ $build->runtime_prop->{dino_path} }, $path->basename;
        }
      }
    },
  );
}

1;
