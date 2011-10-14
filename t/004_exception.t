#!perl -w
use strict;
use Test::More;
use Test::Exception;

use Sub::Spy;


subtest("methods about exception", sub {
    my $subref = sub { die shift; };
    my $spy = Sub::Spy->new($subref);

    $spy->("%%die%%");
    ok ( $spy->threw, "subref throws exception" );
    like ( $spy->exceptions->[0], qr/%%die%%/, "stores first exception" );
    like ( $spy->get_exception(0), qr/%%die%%/, "stores first exception" );

    $spy->("%%hoge%%");
    like ( $spy->get_exception(1), qr/%%hoge%%/, "stores second exception" );

    dies_ok(sub {
        $spy->get_exception(2);
    }, "dies if try to get not-yet-called call");
});

done_testing;
