use Test2::V0 -no_srand => 1;
use Test::Alien::Build;
use Alien::Build::Plugin::Gather::Dino;
use lib 'corpus/lib';

my $build = alienfile_ok filename => 'corpus/libpalindrome.alienfile';

my $alien = alien_build_ok;

note "cflags = ", $alien->cflags;
note "libs   = ", $alien->libs;

my $prefix = $alien->runtime_prop->{prefix};

is( $alien->cflags, "-I$prefix/include " );
is( $alien->libs,   "-L$prefix/lib -lpalindrome " );
is( $alien->runtime_prop->{dino_path}, [ $^O eq 'MSWin32' ? 'bin' : 'lib' ]);

done_testing
