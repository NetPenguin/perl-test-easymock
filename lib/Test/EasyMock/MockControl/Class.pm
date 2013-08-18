package Test::EasyMock::MockControl::Class;
use strict;
use warnings;

=head1 NAME

Test::EasyMock::MockControl::Class - Control behavior of the class method mocking.

=cut
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

    # prevent circular reference
    my ($mock) = @_;
    weaken($mock);

    my $mock_module = Test::MockModule->new($self->{_module});
    foreach my $expectation (@{$self->{_expectations}}) {
        my $method = $expectation->method;
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
