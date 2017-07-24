use Test2::V0 -no_srand => 1;
use Test::Alien::Build;
use Test::Alien;
use Alien::Base::Dino;

alienfile_ok filename => 'corpus/libpalindrome.alienfile';

my $alien = alien_build_ok { class => 'Alien::Base::Dino' };

isa_ok $alien, 'Alien::Base';
isa_ok $alien, 'Alien::Base::Dino';

alien_ok $alien;

xs_ok do { local $/; <DATA> }, with_subtest {
  my($mod) = @_;
  is($mod->is_palindrome("hello"), 0);
  is($mod->is_palindrome("foof"), 1);
};

run_ok(['palx', 'foo'])
  ->note
  ->exit_is(2);

run_ok(['palx', 'foof'])
  ->note
  ->success;

done_testing

__DATA__
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include <libpalindrome.h>

MODULE = TA_MODULE PACKAGE = TA_MODULE

int
is_palindrome(klass, word)
    const char *klass
    const char *word
  CODE:
    RETVAL = is_palindrome(word);
  OUTPUT:
    RETVAL
