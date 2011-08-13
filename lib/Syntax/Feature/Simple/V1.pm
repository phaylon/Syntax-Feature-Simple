use strictures 1;

# ABSTRACT: Version 1 of bundled syntax enhancements

package Syntax::Feature::Simple::V1;

use parent 'Syntax::Feature::Simple';
use syntax qw( method );

method _available_extensions {
    return qw(
        function_keyword
        moose_param_role_method_sugar
        method_keyword
        modifier_sugar
    );
}

method _can_setup_moose_param_role_method_sugar_ext ($class: $target) {
    $class->_check_is_moose_param_role($target)
}

method _can_setup_method_keyword_ext ($class: $target) {
    $class->_check_has_meta($target)
    and not
    $class->_check_is_moose_param_role($target)
}

method _can_setup_modifier_sugar_ext ($class: $target) {
    $class->_check_has_meta($target)
}

1;

__END__

=head1 SYNOPSIS

    use syntax qw( simple/v1 );

=head1 DESCRIPTION

This is the first version of the syntax dispatcher. It will setup a function
keyword in all cases, and a method keyword and method modifiers if a
L<Moose> metaclass was detected.

=head1 SEE ALSO

=over

=item L<Syntax::Feature::Simple>

Main feature documentation.

=back

=cut
