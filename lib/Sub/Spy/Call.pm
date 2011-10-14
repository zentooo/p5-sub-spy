package Sub::Spy::Call;
use strict;
use warnings;

use parent qw/Class::Accessor::Fast/;

__PACKAGE__->mk_ro_accessors(qw/args exception return_value/);

sub new {
    my ($class, $param) = @_;
    return $class->SUPER::new($param);
}

# exception

sub threw {
    return (defined shift->exception) ? 1 : 0;
}


1;
__END__

=head1 NAME

Sub::Spy - Perl extention to do something

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
