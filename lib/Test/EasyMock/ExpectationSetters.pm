package Test::EasyMock::ExpectationSetters;
use strict;
use warnings;

=head1 NAME

Test::EasyMock::ExpectationSetters - Allows setting expectations for an associated expected invocation.

=cut

=head1 CONSTRUCTORS

=head2 new($expectation)

Create a instance.

=cut
sub new {
    my ($class, $expectation) = @_;
    return bless {
        _expectaion => $expectation,
    }, $class;
}

=head1 METHOD

=head2 and_scalar_return($value)

Add scalar result to the expectation.

=cut
sub and_scalar_return {
    my ($self, $scalar) = @_;
    $self->{_expectaion}->push_result(sub { $scalar });
    return $self;
}

=head2 and_array_return(@values)

Add array result to the expectation.

=cut
sub and_array_return {
    my ($self, @array) = @_;
    $self->{_expectaion}->push_result(sub { @array });
    return $self;
}

=head2 and_die([$message])

Add I<die> behavior to the expectation.

=cut
sub and_die {
    my ($self, @args) = @_;
    $self->{_expectaion}->push_result(sub { die @args });
    return $self;
}

=head2 and_stub_scalar_return($value)

Set scalar result as a stub to the expectation.

=cut
sub and_stub_scalar_return {
    my ($self, $scalar) = @_;
    $self->{_expectaion}->set_stub_result(sub { $scalar });
    return $self;
}

=head2 and_stub_array_return(@values)

Set array result as a stub to the expectation.

=cut
sub and_stub_array_return {
    my ($self, @array) = @_;
    $self->{_expectaion}->set_stub_result(sub { @array });
    return $self;
}

=head2 and_stub_die([$message])

Set I<die> behavior as as stub to the expectation.

=cut
sub and_stub_die {
    my ($self, @args) = @_;
    $self->{_expectaion}->set_stub_result(sub { die @args });
    return $self;
}

1;
