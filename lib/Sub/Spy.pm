package Sub::Spy;
use 5.008_001;
use strict;
use warnings;

our $VERSION = '0.01';

use parent qw/Exporter/;
our @EXPORT_OK = qw/spy inspect/;

use Sub::Spy::Result;
use Sub::Spy::Call;


my $store = +{};


sub spy {
    my $subref = shift;

    my $spy;

    $spy = sub {
        my @args = @_;
        my ($result, @array_result, $e);

        if ( wantarray ) {
            @array_result = eval { $subref->(@args); };
        }
        else {
            $result = eval { $subref->(@args); };
        }
        if ( $@ ) {
            $e = $@;
        }

        push @{$store->{$spy + 0}->{calls}}, Sub::Spy::Call->new({
            args => \@args,
            exception => $e,
            return_value => wantarray ? \@array_result : $result,
        });

        return wantarray ? @array_result : $result;
    };

    return $spy;
}

sub inspect {
    my $spy = shift;
    my $param = $store->{$spy + 0} or die "given subroutine reference is not a spy!";
    return Sub::Spy::Result->new($param);
}


1;
__END__

=head1 NAME

Sub::Spy - Sub::Spy is subref wrapper that records arguments, return value, and exception thrown.

=head1 VERSION

This document describes Sub::Spy version 0.01.

=head1 SYNOPSIS

    use Sub::Spy qw/spy inspect/;

    my $subref = sub { return $_[0] * $_[1]; };
    my $spy = spy($subref);

    $spy->(2, 5);

    inspect($spy)->get_call(0)->args; # [2, 5]
    inspect($spy)->get_call(0)->return_value; # 10

    $spy->(3, 3);

    inspect($spy)->args; # [[2, 5], [3, 3]]
    inspect($spy)->return_values; # [10, 9]

    inspect($spy)->get_args(1); # [3, 3]
    inspect($spy)->get_return_value(1); # 9

=head1 DESCRIPTION

# TODO

=head1 INTERFACE

=head2 Functions

=head3 C<< hello() >>

# TODO

=head1 DEPENDENCIES

Perl 5.8.1 or later.

=head1 BUGS

All complex software has bugs lurking in it, and this module is no
exception. If you find a bug please either email me, or add the bug
to cpan-RT.

=head1 SEE ALSO

L<perl>

=head1 AUTHOR

Naosuke Yokoe E<lt>yokoe.naosuke@dena.jpE<gt>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2011, Naosuke Yokoe. All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
