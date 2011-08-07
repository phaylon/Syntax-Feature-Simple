use strictures 1;

# ABSTRACT: Version 1 of bundled syntax enhancements

package Syntax::Feature::Simple::V1;

use Syntax::Feature::Function           0.001;
use Syntax::Feature::Method             0.001;
use Syntax::Feature::Sugar::Callbacks   0.001;

use Carp                    qw( croak );
use Sub::Install    0.925   qw( reinstall_sub );

use syntax qw( method );

my $role_meta = 'MooseX::Role::Parameterized::Meta::Role::Parameterizable';

method install ($class: %args) {
    my $target  = $args{into};
    $class->install_common_syntax($target);
    if (my $meta = $class->has_meta($target)) {
        if ($class->is_parameterized_moose_role($meta)) {
            $class->install_method_sugar($target);
            $class->install_modifier_sugar($target);
        }
        else {
            $class->install_method_keyword($target);
            $class->install_modifier_sugar($target);
        }
    }
    return 1;
}

method has_meta ($class: $target) {
    return $INC{'Moose.pm'}
        ? Moose::Util::find_meta($target)
        : undef;
}

method is_parameterized_moose_role ($class: $meta) {
    return $meta->isa($role_meta);
}

method install_common_syntax ($class: $target) {
    Syntax::Feature::Function->install(
        into    => $target,
        options => { -as => 'fun' },
    );
    return 1;
}

method install_modifier_sugar ($class: $target) {
    Syntax::Feature::Sugar::Callbacks->install(
        into    => $target,
        options => {
            -invocant   => '$self',
            -callbacks  => {
                before  => {},
                after   => {},
                around  => { -before => ['$orig'] },
            },
        },
    );
    return 1;
}

method install_method_sugar ($class: $target) {
    my $orig = $target->can('method')
        or croak qq{There is no 'method' callback installed in '$target'};
    reinstall_sub {
        into    => $target,
        as      => 'method',
        code    => sub {
            return $_[0] if ref $_[0] eq 'CODE';
            goto $orig;
        },
    };
    Syntax::Feature::Sugar::Callbacks->install(
        into    => $target,
        options => {
            -invocant   => '$self',
            -callbacks  => {
                method  => { -allow_anon => 1 },
            },
        },
    );
    return 1;
}

method install_method_keyword ($class: $target) {
    Syntax::Feature::Method->install(
        into    => $target,
        options => { -as => 'method' },
    );
    return 1;
}

1;

__END__

=head1 SYNOPSIS

    use syntax qw( simple/v1 );

=head1 DESCRIPTION

This is the first version (C<v1>) of simple syntax extensions. It will
setup common syntax extensions for L<Moose> classes, roles, parameterized
roles implemented via L<MooseX::Role::Parameterized> and plain Perl
packages.

=head2 Moose Classes and Roles

If a L<Moose> class or role is detected, this extension will setup a C<fun>
keyword for function declarations, a C<method> keyword, and one keyword
each for C<before>, C<after> and C<around>.

The modifiers behave exactly like normal method declarations, except for
C<around> which will provide the original method in a lexical named C<$orig>.

    package MyProject::MooseClassOrRole;
    use Moose;
    # or use Moose::Role
    # or use MooseX::Role::Parameterized,
    #    but with body inside role { ... };
    use syntax qw( simple/v1 );

    fun foo ($x) { ... }
    my $anon_f = fun ($x) { ... };

    method bar ($x) { $self->say($x) }
    my $anon_m = method ($x) { $self->say($x) };

    before baz ($x) { $self->say($x) }
    after  baz ($x) { $self->say($x) }
    around baz ($x) { $self->say($self->$orig($x)) }

    1;

In case of a L<parameterizable role|MooseX::Role::Parameterized> the right
callback will be called, but compatibility with anonymous method declarations
will be preserved:

    package MyProject::ParamRole;
    use MooseX::Role::Parameterized;
    use syntax qw( simple/v1 );

    parameter method_name => (is => 'ro');

    role {
        my $name = $_[0]->method_name;
        method "$name" ($n) { $self->say($n) }
        my $anon = method ($n) { $self->say($n) };
    };

    1;

=head2 Plain Packages

By default, if no other kind of package type is detected, only the function
syntax extension will be exported.

    package MyProject::Util;
    use strictures 1;
    use syntax qw( simple/v1 );

    fun foo ($x) { ... }
    my $anon = fun ($x) { ... };

    1;

=head1 METHODS

=head2 install

    $class->install(into => $target);

Called by L<syntax> dispatcher to install the extension into a target
package.

=head1 SEE ALSO

=over

=item L<Syntax::Feature::Simple>

Contains general information about this extension.

=item L<Syntax::Feature::Method>

Specifics about the C<method> and modifier keywords.

=item L<Syntax::Feature::Function>

Specifics about the C<fun> function keyword.

=item L<Moose>

Post-modern object-orientation.

=back

=cut
