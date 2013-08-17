package Test::EasyMock::MockControl::Class;
use strict;
use warnings;

use parent qw(Test::EasyMock::MockControl);
use Carp qw(confess);
use Scalar::Util qw(weaken);
use Test::MockModule;

sub new {
    my $class = shift;
    my $self = $class->SUPER::new(@_);

    confess('Requires module or object at an argument.(e.g. create_class_mock')
        unless $self->{_module};

    return $self;
}

sub replay {
    my $self = shift;
    $self->SUPER::replay(@_);

    my ($mock) = @_;
    my $mock_module = Test::MockModule->new($self->{_module});
    foreach my $expectation (@{$self->{_expectations}}) {
        my $method = $expectation->method;
        # prevent circular reference
        weaken($mock);

        $mock_module->mock($method => sub {
                               my $class = shift;
                               return $mock->$method(@_);
                           });
    }

    $self->{_mock_module} = $mock_module;
}

sub reset {
    my $self = shift;
    $self->SUPER::reset(@_);
    $self->{_mock_module} = undef;
}

1;
