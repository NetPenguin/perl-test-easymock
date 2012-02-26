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
        _results => [ { code => sub { return; }, implicit => 1 } ],
    }, $class;
}

sub mock {
    my ($self) = @_;
    return $self->{_mock};
}

sub push_result {
    my ($self, $code) = @_;
    $self->remove_implicit_result();
    push @{$self->{_results}}, { code => $code };
}

sub set_stub_result {
    my ($self, $code) = @_;
    $self->remove_implicit_result();
    $self->{_stub_result} = { code => $code };
}

sub remove_implicit_result {
    my ($self) = @_;
    $self->{_results} = [
        grep { !$_->{implicit} } @{$self->{_results}}
    ];
}

sub retrieve_result {
    my ($self) = @_;
    my $result = shift @{$self->{_results}} || $self->{_stub_result};
    croak('no result.') unless $result;
    return $result->{code}->();
}

sub has_result {
    my ($self) = @_;
    return @{$self->{_results}} > 0;
}

sub has_stub_result {
    my ($self) = @_;
    return exists $self->{_stub_result};
}

sub matches {
    my ($self, $args) = @_;
    return refaddr($self->{_mock}) == refaddr($args->{mock})
        && $self->{_method} eq $args->{method}
        && eq_array($self->{_args}, $args->{args});
}

sub is_satisfied {
    my ($self) = @_;
    return !$self->has_result;
}

sub unsatisfied_message {
    my ($self) = @_;
    return sprintf(
        '%d calls of the `%s` method expected exist.',
        scalar(@{$self->{_results}}),
        $self->{_method}
    ) if $self->has_result;

    return;
}

1;
