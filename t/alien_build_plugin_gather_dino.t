use Test2::V0 -no_srand => 1;
use Test::Alien::Build;
use Alien::Build::Plugin::Gather::Dino;
use Alien::Base::Dino;
use lib 'corpus/lib';

my $build = alienfile_ok filename => 'corpus/libpalindrome.alienfile';

my $alien = alien_build_ok { class => 'Alien::Base::Dino' };

note "cflags = ", $alien->cflags;
note "libs   = ", $alien->libs;

my $prefix = $alien->runtime_prop->{prefix};

like( $alien->cflags, qr{-I$prefix/include} );
like( $alien->libs,   qr{-L$prefix/lib -lpalindrome} );
is( $alien->runtime_prop->{rpath}, [ $^O =~ /^(MSWin32|cygwin)$/ ? 'bin' : 'lib' ]);

done_testing
