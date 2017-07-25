# Alien::Base::Dino [![Build Status](https://secure.travis-ci.org/plicease/Alien-Base-Dino.png)](http://travis-ci.org/plicease/Alien-Base-Dino)

Experimental support for dynamic share Alien install

# BASE CLASS

This class is a subclass of [Alien::Base](https://metacpan.org/pod/Alien::Base) and as such, in inherits all
of its methods and properties.

# METHODS

## xs\_load

    $alien->xs_load($package, $version);
    $alien->xs_load($package, $version, @other_dino_aliens);

## rpath

    my @dirs = $alien->rpath;

Returns the list of directories that have non-system dynamic libraries
in them.  On some systems this is needed at compile time, on others
it is needed at run time.

## libs

    my $libs = $alien->libs;

On some platforms, this subclass overrides the behavior of the `libs` method.

# AUTHOR

Graham Ollis <plicease@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2017 by Graham Ollis.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
