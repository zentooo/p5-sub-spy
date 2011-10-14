#!perl -w
use strict;
use Test::More;

use Sub::Spy;

subtest("methods with single return value", sub {
    my $subref = sub { return shift; };
    my $spy = Sub::Spy->new($subref);

    my $res = $spy->(1);
    is ( $spy->return_values->[0], 1, "return value 1 recorded" );
    is ( $spy->return_values->[0], $spy->get_return_value(0), "return value 1 recorded" );
});

subtest("methods with multiple return values", sub {
    my $subref = sub { return @_; };
    my $spy = Sub::Spy->new($subref);

    my ( $one, $two, $three ) = $spy->(1, "foo", +{});
    is ( $spy->return_values->[0]->[0], 1, "return value 1 recorded" );
    is ( $spy->return_values->[0]->[1], "foo", "return value 1 recorded" );

    is ( $spy->return_values->[0]->[0], $spy->get_return_value(0)->[0], "return value 1 recorded" );
    is ( $spy->return_values->[0]->[1], $spy->get_return_value(0)->[1], "return value 1 recorded" );

    my ( $four, $five, $six ) = $spy->(2, "bar", +{});
    is ( $spy->get_return_value(1)->[0], 2, "return value 2 recorded" );
    is ( $spy->get_return_value(1)->[1], "bar", "return value 2 recorded" );
});

done_testing;
