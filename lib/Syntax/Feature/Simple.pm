use strict;
use warnings;

# ABSTRACT: DWIM syntax extensions

package Syntax::Feature::Simple;

use Carp qw( croak );

use syntax qw( method );

method install {
    croak q{You cannot use 'simple' as a syntax extension. You need to }
        . q{select a specific version, for example 'simple/v1'};
}

1;

__END__

=head1 DESCRIPTION

This is a more of a syntax extension package than a simple extension by
itself. It will detect what kind of package it is imported into, and setup
appropriate syntax extensions depending on the type.

See L<Syntax::Feature::Simple::V1> for the first version of the extension set.

=head1 SEE ALSO

=over

=item L<Syntax::Feature::Simple::V1>

Version 1 of the extension set.

=item L<syntax>

The syntax dispatching module.

=back

=cut
