package Test::EasyMock::MockControl;
use strict;
use warnings;

use Data::Dumper;
use List::Util qw(first);
use Scalar::Util qw(refaddr);
use Test::EasyMock::Expectation;
use Test::EasyMock::ExpectationSetters;
use Test::EasyMock::MockObject;
use Test::More;

sub create_control {
    my $class = shift;
    return $class->new(@_);
}

sub new {
    my $class = shift;
    return bless {}, $class;
}

sub create_mock {
    my ($self) = @_;
    return bless {
	_control => $self,
    }, 'Test::EasyMock::MockObject';
}

sub process_method_invocation {
    my ($self, $mock, $method, @args) = @_;
    return $self->{_is_replay_mode}
	? $self->replay_method_invocation($mock, $method, @args)
	: $self->record_method_invocation($mock, $method, @args);
}

sub replay_method_invocation {
    my ($self, $mock, $method, @args) = @_;
    my $expectation = $self->find_expectation({
	mock => $mock,
	method => $method,
	args => \@args,
    });

    my $method_detail = "(method: $method, args: "
                       . Data::Dumper->new(\@args)->Indent(0)->Dump .')';

    if ($expectation) {
	pass('Expected mock method invoked.'.$method_detail);
	return $expectation->retrieve_result();
    }
    else {
	fail('Unexpected mock method invoked.'.$method_detail);
	return;
    }
}

sub record_method_invocation {
    my ($self, $mock, $method, @args) = @_;
    return Test::EasyMock::Expectation->new({
	mock => $mock,
	method => $method,
	args => \@args,
    });
}

sub find_expectation {
    my ($self, $args) = @_;
    my @expectations = grep { $_->matches($args) }
                            @{$self->{_expectations}};

    my $result = first { $_->has_result } @expectations;
    return $result || first { $_->has_stub_result } @expectations;
}

sub expect {
    my ($self, $expectation) = @_;
    push @{$self->{_expectations}}, $expectation;
    return Test::EasyMock::ExpectationSetters->new($expectation);
}

sub replay {
  my ($self) = @_;
  $self->{_is_replay_mode} = 1;
}

sub reset {
  my ($self) = @_;
  $self->{_is_replay_mode} = 0;
  $self->{_expectations} = [];
}

sub verify {
  my ($self) = @_;
  my $unsatisfied_message =
    join "\n", map { $_->unsatisfied_message }
              grep { !$_->is_satisfied }
		   @{$self->{_expectations}};
  is($unsatisfied_message, '', 'verify mock invocations.');
}

1;
