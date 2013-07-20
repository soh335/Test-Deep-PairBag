use strict;
use warnings;
use utf8;

use Test::Tester;
use Test::More;

use Test::Deep;
use Test::Deep::PairBag;

{
    check_test sub {
        cmp_deeply(
            [foo => 1, bar => 2, foo => 2],
            pair_bag(foo => 1, bar => 2, foo => 2),
        );
    }, {
        ok => 1,
    };
}

{
    check_test sub {
        cmp_deeply(
            [foo => 1, bar => 2, foo => 2],
            pair_bag(foo => 2, foo => 1, bar => 2),
        );
    }, {
        ok => 1,
    };
}

{
    my ($premature, @results) = run_tests sub {
        cmp_deeply(
            [foo => 1, bar => 2, foo => 2],
            pair_bag(foo => 2, foo => 1, bar => 3),
        );
    };

    my $diag = <<EOM;
Missing: 'bar' => '3'
Extra: 'bar' => '2'
got    : 'foo' => '1','bar' => '2','foo' => '2'
expect : 'foo' => '2','foo' => '1','bar' => '3'
EOM

    is $results[0]->{ok}, 0;
    like $results[0]->{diag}, qr/$diag/;
}

{
    my ($premature, @results) = run_tests sub {
        cmp_deeply(
            [foo => 1, bar => 2, foo => 2],
            pair_bag(foo => 2, foo => 1),
        );
    };

    my $diag = <<EOM;
Extra: 'bar' => '2'
got    : 'foo' => '1','bar' => '2','foo' => '2'
expect : 'foo' => '2','foo' => '1'
EOM

    is $results[0]->{ok}, 0;
    like $results[0]->{diag}, qr/$diag/;
}

{
    my ($premature, @results) = run_tests sub {
        cmp_deeply(
            { foo => 1, bar => 2, foo => 2 },
            pair_bag(foo => 2, foo => 1),
        );
    };

    my $diag = <<EOM;
got    : HASH\(.*\)
expect : should be array ref
EOM

    is $results[0]->{ok}, 0;
    like $results[0]->{diag}, qr/$diag/;
}

done_testing;
