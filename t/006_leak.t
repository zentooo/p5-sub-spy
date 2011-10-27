#!perl -w
use strict;
use Test::More;

use Sub::Spy qw/spy inspect/;

subtest("no leak thanks to Hash::FieldHash", sub {
    {
        my $subref = sub { return shift; };
        my $spy = spy($subref);
        $spy->();
        is ( scalar (keys %Sub::Spy::store), 1, "information stored in fieldhash" );
    }

    is ( scalar (keys %Sub::Spy::store), 0, "information removed from fieldhash" );
});

done_testing;
