package Test::EasyMock::ExpectationSetters;
use strict;
use warnings;

sub new {
    my ($class, $expectation) = @_;
    return bless {
        _expectaion => $expectation,
    }, $class;
}

sub and_scalar_return {
    my ($self, $scalar) = @_;
    $self->{_expectaion}->push_result(sub { $scalar });
    return $self;
}

sub and_array_return {
    my ($self, @array) = @_;
    $self->{_expectaion}->push_result(sub { @array });
    return $self;
}

sub and_die {
    my ($self, @args) = @_;
    $self->{_expectaion}->push_result(sub { die @args });
    return $self;
}

sub and_stub_scalar_return {
    my ($self, $scalar) = @_;
    $self->{_expectaion}->set_stub_result(sub { $scalar });
    return $self;
}

sub and_stub_array_return {
    my ($self, @array) = @_;
    $self->{_expectaion}->set_stub_result(sub { @array });
    return $self;
}

sub and_stub_die {
    my ($self, @args) = @_;
    $self->{_expectaion}->set_stub_result(sub { die @args });
    return $self;
}

1;
