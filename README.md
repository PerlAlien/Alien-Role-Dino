# Alien::Role::Dino ![linux](https://github.com/PerlAlien/Alien-Role-Dino/workflows/linux/badge.svg) ![static](https://github.com/PerlAlien/Alien-Role-Dino/workflows/static/badge.svg)

Experimental support for dynamic share Alien install

# SYNOPSIS

In your [alienfile](https://metacpan.org/pod/alienfile):

```perl
use alienfile;

share {
  ...
  plugin 'Gather::Dino';
}
```

Apply [Alien::Role::Dino](https://metacpan.org/pod/Alien::Role::Dino) to your [Alien::Base](https://metacpan.org/pod/Alien::Base) subclass:

```perl
package Alien::libfoo;

use base qw( Alien::Base );
use Role::Tiny::With qw( with );

with 'Alien::Role::Dino';

1;
```

And finally from the .pm side of your XS module:

```perl
package Foo::XS;

use Alien::libfoo;

our $VERSION = '1.00';

# Note caveat: your Alien is now a run-time
# dependency of your XS module.
Alien::libfoo->xs_load(__PACKAGE__, $VERSION);

1;
```

# DESCRIPTION

Every now and then someone will ask me why thus and such [Alien](https://metacpan.org/pod/Alien) thing 
doesn't work with a dynamic library error.  My usual response is can you 
make it work with static libraries?  The reason for this is that 
**building** dynamic libraries for an [Alien](https://metacpan.org/pod/Alien) **share** install introduce 
a number of challenges, and honestly I don't see the point of using 
them, if you can avoid it.  So far I haven't actually seen a situation 
where it couldn't be avoided.  Just to be clear: dynamic libraries are 
fine for Alien, and in fact desirable when you are using the system 
provided libraries.  You get the patches and security fixes supplied by 
your operating system.

Okay, so why not build a dynamic library for a **share** install?

For this discussion, say you have an alienized library `Alien::libfoo` 
and an XS module that uses it called `Foo::XS` (as illustrated in the 
synopsis above).

- Your Alien becomes a run-time dependency.

    When you link your `Foo::XS` module with a static library from 
    `Alien::libfoo` it gets added into the DLL or `.so` file that the Perl 
    toolchain produces.  That means when you later use it, it doesn't need 
    anything else.  When you try to do the same thing with a dynamic 
    library, you need that dynamic library, which is stored in a share 
    directory of `Alien::libfoo`.

    For people who install out of CPAN this is probably not a big deal, but 
    for operating system vendors (the people who integrate Perl modules into 
    their operating system), it is a hassle because now you need this big 
    build tool [Alien::Build](https://metacpan.org/pod/Alien::Build) and the alien `Alien::libfoo` with extra 
    dependencies during runtime.  Normally you wouldn't need those packages 
    installed for end-user use.

- Upgrades can and will break your XS module.

    Again, when `Alien::libfoo` builds a static library and it gets linked 
    into a DLL or `.so` for `Foo::XS`, it doesn't need the original 
    library anymore.  If you are using a dynamic library and you do the same 
    thing it maybe works today, but say tomorrow you upgrade 
    `Alien::libfoo` and it replaces the DLL or `.so` file with an 
    incompatible API or ABI?  Now your `Foo::XS` module has stopped 
    working!

- Dynamic libraries are not portable

    Dynamic libraries are widely supported on most modern operating systems, 
    but each system provides a different interface.  For example, Linux, 
    Windows and OS X all have an environment variable that allows you to 
    alter the search path for finding dynamic libraries, but all three have 
    different extensions for dynamic libraries (OS X even has two!), the 
    environment variables are called something different, and WHEN you can 
    change them is different.

    The Perl core has code for loading dynamic libraries as part of its XS 
    system on all platforms where you can build XS extensions dynamically. 
    Unfortunately that code isn't quite reusable for use by Alien.  Alien 
    developers have limited time and access to many platforms, which means 
    that many platforms will probably never get Alien support.

    Static libraries on the other hand pretty much work the same on all 
    platforms.  Even on Windows which likes to be different, static 
    libraries are essentially the same as on Unix.

So all that said, why have I written this module, which provides support 
for dynamic libraries?  Well, maybe I am wrong, maybe it isn't that 
hard.  Also, maybe you don't have a choice, maybe you have found a 
library that can ONLY be built using a dynamic library.

What about you?  Should you use this module?  It has the worked 
**Experimental** in the description.  The experimental aspect of this 
module should not worry you, because in the situation that your Alien 
finds the library from the system, nothing is different from the core 
[Alien::Build](https://metacpan.org/pod/Alien::Build).  The only place it is different is if you have to do a 
share install, and hopefully you are only using it because you really 
can't build a static library.  Thus you haven't really lost anything in 
stability, and at worst your Alien may work in places where it wouldn't 
otherwise.

So in summary, the experimental aspect shouldn't worry you, the caveats 
above should!

# HOW

How does it work?  Use the bundled [alienfile](https://metacpan.org/pod/alienfile) plugin 
[Alien::Build::Plugin::Gather::Dino](https://metacpan.org/pod/Alien::Build::Plugin::Gather::Dino).  That will find any dynamic 
library paths in your share directory in case they are needed at 
runtime.  Then apply this role to you [Alien::Base](https://metacpan.org/pod/Alien::Base) subclass using
[Role::Tiny::With](https://metacpan.org/pod/Role::Tiny::With).  Instead of using [XSLoader](https://metacpan.org/pod/XSLoader) or [DynaLoader](https://metacpan.org/pod/DynaLoader)
to load your XS module, use the `xs_load` from your [Alien](https://metacpan.org/pod/Alien).
Hopefully the synopsis above makes it clear.

# ETYMOLOGY

This module is named **Dino** being short for Dinosaur.  I really like 
Dinosaurs (also friendly crocodiles and [platypuses](https://metacpan.org/pod/FFI::Platypus) in 
case you hadn't noticed).  "Dino" also has a similar sound to "Dyna" 
which is frequently used as a short name or prefix meaning "dynamic".  I 
didn't want to call it "Dyna" or "Dynamic" since it is only building a 
dynamic library for share installs.  I didn't want to call it DynaShare 
because that was getting a bit wordy.  So Dino.

# METHODS

## rpath

```perl
my @dirs = $alien->rpath;
```

Returns the list of directories that have non-system dynamic libraries
in them.  On some systems this is needed at compile time, on others
it is needed at run time.

## xs\_load

```
$alien->xs_load($package, $version);
$alien->xs_load($package, $version, @other_dino_aliens);
```

# CAVEATS

Lots.  In summary:

- Your Alien is a run-time dependency and you will annoy system integrators
- Your XS can be broken by upgrades to your Alien
- Your platform may not be supported

Also, this module should start with the caveat section and then go from 
there.  Most modules I write are not like that.

These platforms seem to work: Linux, OS X, Windows, Cygwin, FreeBSD, 
NetBSD, OpenBSD, Debian kFreeBSD.

Currently has [Alien::Autotools](https://metacpan.org/pod/Alien::Autotools) as a prerequisite.  I hope to remove that prereq
asap.

# SEE ALSO

- [alienfile](https://metacpan.org/pod/alienfile)
- [Alien::Base](https://metacpan.org/pod/Alien::Base)
- [Alien::Build](https://metacpan.org/pod/Alien::Build)
- [Alien::Build::Plugin::Gather::Dino](https://metacpan.org/pod/Alien::Build::Plugin::Gather::Dino)

# AUTHOR

Graham Ollis <plicease@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2017-2022 by Graham Ollis.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
