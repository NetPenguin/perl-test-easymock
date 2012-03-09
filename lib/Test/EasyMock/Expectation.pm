package Test::EasyMock::Expectation;
use strict;
use warnings;

=head1 NAME

Test::EasyMock::Expectation - A expected behavior object.

=cut
use Carp qw(croak);
use Scalar::Util qw(refaddr);
use Test::More; # use eq_array.

=head1 CONSTRUCTORS

=head2 new({mock=>$mock, method=>$method, args=>$args})

Create a instance.

=cut
sub new {
    my ($class, $args) = @_;
    return bless {
        _mock => $args->{mock},
        _method => $args->{method},
        _args => $args->{args},
        _results => [ { code => sub { return; }, implicit => 1 } ],
    }, $class;
}

=head1 PROPERTIES

=head2 mock - A related mock object.

=cut
sub mock {
    my ($self) = @_;
    return $self->{_mock};
}

=head1 METHODS

=head2 push_result($code)

Add a method result behavior.

=cut
sub push_result {
    my ($self, $code) = @_;
    $self->remove_implicit_result();
    push @{$self->{_results}}, { code => $code };
}

=head2 set_stub_result($code)

Set a method result behavior as stub.

=cut
sub set_stub_result {
    my ($self, $code) = @_;
    $self->remove_implicit_result();
    $self->{_stub_result} = { code => $code };
}

=head2 remove_implicit_result()

Remove results which flagged with 'implicit'.

=cut
sub remove_implicit_result {
    my ($self) = @_;
    $self->{_results} = [
        grep { !$_->{implicit} } @{$self->{_results}}
    ];
}

=head2 retrieve_result()

Retrieve a result value.

=cut
sub retrieve_result {
    my ($self) = @_;
    my $result = shift @{$self->{_results}} || $self->{_stub_result};
    croak('no result.') unless $result;
    return $result->{code}->();
}

=head2 has_result

It is tested whether it has a result.

=cut
sub has_result {
    my ($self) = @_;
    return @{$self->{_results}} > 0;
}

=head2 has_stub_result

It is tested whether it has a stub result.

=cut
sub has_stub_result {
    my ($self) = @_;
    return exists $self->{_stub_result};
}

=head2 matches($args)

It is tested whether the specified argument matches.

=cut
sub matches {
    my ($self, $args) = @_;
    return refaddr($self->{_mock}) == refaddr($args->{mock})
        && $self->{_method} eq $args->{method}
        && eq_array($self->{_args}, $args->{args});
}

=head2 is_satisfied()

The call to expect tests whether it was called briefly.

=cut
sub is_satisfied {
    my ($self) = @_;
    return !$self->has_result;
}

=head2 unsatisfied_message()

The message showing a lacking call is acquired.

=cut
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
