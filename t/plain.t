use strictures 1;
use Test::More 0.98;

do {
    package MyTest::Plain;
    use syntax qw( simple/v1 );
    fun foo ($x) { fun ($y) { $x + $y } };
    ::is(foo(23)->(17), 40, 'function definitions');
};

done_testing;
