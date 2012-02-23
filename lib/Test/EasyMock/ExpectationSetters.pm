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
    $self->{_expectaion}->push_return(sub { $scalar });
    return $self;
}

sub and_array_return {
    my ($self, @array) = @_;
    $self->{_expectaion}->push_return(sub { @array });
    return $self;
}

sub and_die {
    my ($self, @args) = @_;
    $self->{_expectaion}->push_return(sub { die @args });
    return $self;
}

1;
