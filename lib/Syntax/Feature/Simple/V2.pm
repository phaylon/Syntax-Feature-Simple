use strictures 1;

# ABSTRACT: Version 2 of bundled syntax enhancements

package Syntax::Feature::Simple::V2;

use parent 'Syntax::Feature::Simple::V1';
use syntax qw( method );

method _can_setup_method_keyword_ext ($class: $target) {
    not $class->_check_is_moose_param_role($target)
}

1;

__END__

=head1 SYNOPSIS

    use syntax qw( simple/v2 );

=head1 DESCRIPTION

This is the second version of the syntax dispatcher. It will setup a function
and a method keyword in all cases, and a set of method modifiers if any kind
of L<Moose> metaclass was detected.

=head1 SEE ALSO

=over

=item L<Syntax::Feature::Simple>

Main feature documentation.

=back

=cut
