# NAME

Test::Deep::PairBag - compare arrayref as hashref stored mutiple value per key by Test::Deep

# SYNOPSIS

    use Test::Deep;
    use Test::Deep::PairBag;

    cmp_deeply(
        [ foo => 1, bar => 2, foo => 3 ],
        pair_bag(foo => 1, foo => 3, bar => 2)
    );

# DESCRIPTION

Test::Deep::PairBag compare arrayref as hashref stored mutiple value per key by [<Test::Deep](http://search.cpan.org/perldoc?<Test::Deep)\>.

In Test::Deep::PairBag, got array and expected array are took out two elements and wraped as arrayref.
So, `<[foo =` 1, bar => 2, foo => 3\]>> is translated to `<[ [foo =` 1\], \[ba => 2\], \[foo => 3\] \]>>.
And, comparing them by `<Test::Deep::bag`\>.

# Functions

- pair\_bag($expected)

    _$expected_ should be array reference.

# LICENSE

Copyright (C) soh335.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

# AUTHOR

soh335 <sugarbabe335@gmail.com>
