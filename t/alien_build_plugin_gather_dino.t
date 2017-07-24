use Test2::V0 -no_srand => 1;
use Test::Alien::Build;
use Alien::Build::Plugin::Gather::Dino;

my $build = alienfile_ok q{
  use alienfile;
  
  plugin 'Gather::Dino';
};

done_testing
