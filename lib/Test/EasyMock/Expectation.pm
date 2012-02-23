package Test::EasyMock::Expectation;
use strict;
use warnings;

use Test::More;
use Scalar::Util qw(refaddr);

sub new {
    my ($class, $args) = @_;
    return bless {
	_mock => $args->{mock},
	_method => $args->{method},
	_args => $args->{args},
	_returns => [],
	_count => 0,
    }, $class;
}

sub mock {
    my ($self) = @_;
    return $self->{_mock};
}

sub push_return {
    my ($self, $code) = @_;
    push @{$self->{_returns}}, $code;
}

sub retrieve_return {
    my ($self) = @_;
    my $code = shift @{$self->{_returns}};
    $self->{_count} += 1;
    return unless $code;
    return $code->();
}

sub match {
    my ($self, $args) = @_;
    # MEMO: any_times を実装する場合、is_satisfied では判定できなくなる
    #       (any_times の場合、0回実行でも is_satisfied は真となる)
    return !$self->is_satisfied
	&& refaddr($self->{_mock}) == refaddr($args->{mock})
	&& $self->{_method} eq $args->{method}
        && eq_array($self->{_args}, $args->{args});
}

sub is_satisfied {
    my ($self) = @_;
    return scalar(@{$self->{_returns}}) == 0
	&& $self->{_count} > 0;
}

sub unsatisfied_message {
    my ($self) = @_;
    return sprintf(
	'%d calls of the `%s` method expected exist.',
	scalar(@{$self->{_returns}}),
	$self->{_method}
    ) if scalar(@{$self->{_returns}}) > 0;

    return sprintf(
        'the `%s` method is not invoked.',
        $self->{_method}
    ) if $self->{_count} == 0;

    return;
}

1;
