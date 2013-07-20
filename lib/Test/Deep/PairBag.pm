package Test::Deep::PairBag;
use 5.008005;
use strict;
use warnings;
use parent qw(Exporter);

our $VERSION = "0.01";

use Test::Deep ();
use Test::Deep::Cmp;
use Test::Deep::Set ();

our @EXPORT = qw(pair_bag);

sub pair_bag {
    __PACKAGE__->new(@_);
}

sub init {
    my $self = shift;
    my @values = @_;

    $self->{val} = \@values;
}

sub descend {
    my ($self, $got) = @_;

    # check: $got should be ARRAY
    if ( ref $got ne 'ARRAY' ) {
        $self->{error} = <<EOM;
got    : @{[Test::Deep::render_val($got)]}
expect : should be array ref
EOM
        return;
    }

    no warnings 'once', 'redefine';
    local *Test::Deep::Set::nice_list = sub {
        my $list = shift;
        join ",", map { _render_pair($_->[0], $_->[1]) } @$list;
    };

    Test::Deep::bag(_paired(@{ $self->{val} }))->descend([_paired(@$got)]);
}

sub diagnostics {
    my ($self, $where, $last) = @_;

    if ( $self->{error} ) {
        return $self->{error};
    }

    my $got = $self->renderGot($last->{got});
    my $expected = $self->renderExp;
    my $message = $last->{diag};

    my $diag = <<EOM;
$message
got    : $got
expect : $expected
EOM
}


sub renderGot {
    my ($self, $got) = @_;
    _render_val(@$got);
}

sub renderExp {
    my $self = shift;
    _render_val(@{ $self->{val} });
}

sub _render_val {
    my @values = @_;

    my @strs;

    while ( my ($k, $v) = splice @values, 0, 2 ) {
        push @strs, _render_pair($k, $v);
    }

    join ",", @strs;
}

sub _render_pair {
    my ($k, $v) = @_;
    sprintf "%s => %s", Test::Deep::render_val($k), Test::Deep::render_val($v);
}

sub _paired {
    my @values = @_;

    my @pair_values;

    while ( my ($k, $v) = splice @values, 0, 2 ) {
        push @pair_values, [$k, $v];
    }

    @pair_values;
}

1;
__END__

=encoding utf-8

=head1 NAME

Test::Deep::PairBag - compare arrayref as hashref stored mutiple value per key by Test::Deep

=head1 SYNOPSIS

    use Test::Deep;
    use Test::Deep::PairBag;

    cmp_deeply(
        [ foo => 1, bar => 2, foo => 3 ],
        pair_bag(foo => 1, foo => 3, bar => 2)
    );

=head1 DESCRIPTION

Test::Deep::PairBag compare arrayref as hashref stored mutiple value per key by L<<Test::Deep>>.

In Test::Deep::PairBag, got array and expected array are took out two elements and wraped as arrayref.
So, C<<[foo => 1, bar => 2, foo => 3]>> is translated to C<<[ [foo => 1], [ba => 2], [foo => 3] ]>>.
And, comparing them by C<<Test::Deep::bag>>.

=head1 Functions

=over 4

=item pair_bag($expected)

I<$expected> should be array reference.

=back

=head1 LICENSE

Copyright (C) soh335.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

soh335 E<lt>sugarbabe335@gmail.comE<gt>

=cut

