#!perl -w
use strict;
use Test::More;
use Test::Exception;

use Sub::Spy;


subtest("methods about args", sub {
    my $subref = sub { return shift; };
    my $spy = Sub::Spy->new($subref);

    $spy->("foo", "bar");
    is ( scalar @{$spy->args}, 1, "args recorded" );
    is ( $spy->args->[0]->[0], "foo", "args recorded" );

    $spy->("bar", "foobar");

    is ( $spy->get_args(0)->[0], "foo", "get_args recorded" );
    is ( $spy->get_args(0)->[1], "bar", "get_args recorded" );

    is ( $spy->get_args(1)->[0], "bar", "get_args recorded" );
    is ( $spy->get_args(1)->[1], "foobar", "get_args recorded" );

    dies_ok(sub {
        $spy->get_args(2)->[1];
    }, "dies if try to get not-yet-called call.");
});

done_testing;
