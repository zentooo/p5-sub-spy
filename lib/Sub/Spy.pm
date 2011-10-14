package Sub::Spy;
use 5.008_001;
use strict;
use warnings;

our $VERSION = '0.01';

use List::MoreUtils qw/any/;
use Data::Dump qw/dump/;

use Sub::Spy::Call;


sub new {
    my ($class, $subref) = @_;

    return bless +{
        subref => $subref,
        calls => [],
    }, $class;
}

sub subref {
    my $self = shift;
    return $self->{subref};
}

sub get_call {
    my ($self, $n) = @_;
    $self->{calls}->[$n];
}

use overload '&{}' => sub {
    my $self = shift;

    return sub {
        my @args = @_;
        my ($result, @array_result, $e);

        if ( wantarray ) {
            @array_result = eval { $self->subref->(@args); };
        }
        else {
            $result = eval { $self->subref->(@args); };
        }
        if ( $@ ) {
            $e = $@;
        }

        push @{$self->{calls}}, Sub::Spy::Call->new({
            args => \@args,
            exception => $e,
            return_value => wantarray ? \@array_result : $result,
        });

        return wantarray ? @array_result : $result;
    };
};


# count

sub call_count {
    return scalar @{shift->{calls}};
}

sub called {
    return (shift->call_count > 0) ? 1 : 0;
}

sub called_times {
    my ($self, $times) = @_;
    return ($self->call_count == $times) ? 1 : 0;
}

sub called_once {
    return shift->called_times(1);
}

sub called_twice {
    return shift->called_times(2);
}

sub called_thrice {
    return shift->called_times(3);
}


# args

sub args {
    my $self = shift;
    return [map { $_->args } @{$self->{calls}}];
}

sub get_args {
    my ($self, $n) = @_;
    die "try to get arguments of not-yet-called call." if $n >= scalar @{$self->{calls}};
    return $self->args->[$n];
}


# exception

sub exceptions {
    my $self = shift;
    return [map { $_->exception } @{$self->{calls}}];
}

sub get_exception {
    my ($self, $n) = @_;
    die "try to get exception of not-yet-called call." if $n >= scalar @{$self->{calls}};
    return $self->exceptions->[$n];
}

sub threw {
    my $self = shift;
    return ( any { defined($_) } @{$self->exceptions} ) ? 1 : 0;
}


# return

sub return_values {
    my $self = shift;
    return [map { $_->return_value } @{$self->{calls}}];
}

sub get_return_value {
    my ($self, $n) = @_;
    die "try to get return value of not-yet-called call." if $n >= scalar @{$self->{calls}};
    return $self->return_values->[$n];
}


1;
__END__

=head1 NAME

Sub::Spy - Sub::Spy is subref wrapper that records arguments, return value, and exception threw.

=head1 VERSION

This document describes Sub::Spy version 0.01.

=head1 SYNOPSIS

    use Sub::Spy;

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
