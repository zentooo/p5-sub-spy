#!perl -w
use strict;
use Test::More;

use Sub::Spy;

subtest("new with subref that returns single value", sub {
    my $subref = sub { return shift; };
    my $spy = Sub::Spy->new($subref);

    is ( $spy->(10), 10, "spy is callable and executes wrapped subref" );
    is ( $spy->(20), $subref->(20), "results of subref call and spy call just matches" );
});

subtest("new with subref that returns multiple values", sub {
    my $subref = sub { return (1, 2, 3); };
    my $spy = Sub::Spy->new($subref);

    my ( $one, $two, $three ) = $spy->();
    is ( $one, 1 );
    is ( $two, 2 );
    is ( $three, 3 );

    is ( $spy->(), 3, "return array length if called with scalar context" );
});

subtest("get_call", sub {
    my $subref = sub { return shift->(); };

    my $spy = Sub::Spy->new($subref);

    $spy->(sub { return 1 });
    is ( $spy->get_call(0)->return_value, 1, "first call result is 1" );
    is ( $spy->get_call(0)->exception, undef, "first call did not throw exception" );
    is ( ref $spy->get_call(0)->args->[0], "CODE", "first call arg is subref" );

    $spy->(sub { die '%%die%%' });
    like ( $spy->get_call(1)->exception, qr/%%die%%/, "second call exception is ..." );
    is ( $spy->get_call(1)->return_value, undef, "second call did not return value" );
});

done_testing;
