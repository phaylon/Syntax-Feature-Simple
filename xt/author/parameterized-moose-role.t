use strictures 1;
use Test::More 0.98;

do {
    package MyTest::ParamRole;
    use MooseX::Role::Parameterized;
    use syntax qw( simple/v1 );
    parameter name => (is => 'ro');
    fun foo ($x) { fun ($y) { $x + $y } };
    ::is(foo(23)->(17), 40, 'function definitions');
    role {
        my $name = (shift)->name;
        method "$name" ($x) { $x }
        my %modifier;
        before "$name" ($x) { $modifier{before} = $x }
        after  "$name" ($x) { $modifier{after}  = $x }
        around "$name" ($x) { $modifier{around} = $x; $self->$orig($x) }
        method modifiers { %modifier }
        method anonymous { method ($x) { $x * 2 } }
    };
};

do {
    package MyTest::Consumer;
    use Moose;
    with 'MyTest::ParamRole' => { name => 'foo' };
    my $class = __PACKAGE__;
    ::is($class->foo(23), 23, 'method value passing');
    my %modifier = $class->modifiers;
    ::is($modifier{ $_ }, 23, "correct value in $_")
        for qw( before after around );
    ::is($class->${\($class->anonymous)}(23), 46, 'anonymous methods');
};

done_testing;
