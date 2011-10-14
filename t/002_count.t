#!perl -w
use strict;
use Test::More;

use Sub::Spy;

subtest("basic methods about count", sub {
    my $subref = sub { return shift; };
    my $spy = Sub::Spy->new($subref);

    $spy->();
    is ( $spy->call_count, 1, "spy call count = 1" );
    ok ( $spy->called, "spy has called!" );
    ok ( $spy->called_times(1), "spy has called once" );

    $spy->();
    is ( $spy->call_count, 2, "spy call count = 1" );
    ok ( $spy->called_times(2), "spy has called twice" );
});

subtest("methods about count", sub {
    my $subref = sub { return shift; };
    my $spy = Sub::Spy->new($subref);

    $spy->();
    ok ( $spy->called_once, "spy called once" );

    $spy->();
    ok ( $spy->called_twice, "spy called twice" );

    $spy->();
    ok ( $spy->called_thrice, "spy called thrice" );
});

done_testing;
