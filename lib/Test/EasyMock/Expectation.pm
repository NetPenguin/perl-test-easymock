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
    # MEMO: any_times $B$r<BAu$9$k>l9g!"(Bis_satisfied $B$G$OH=Dj$G$-$J$/$J$k(B
    #       (any_times $B$N>l9g!"(B0$B2s<B9T$G$b(B is_satisfied $B$O??$H$J$k(B)
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
