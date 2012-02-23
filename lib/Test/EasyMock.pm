package Test::EasyMock;
use strict;
use warnings;

use Carp qw(confess);
use Exporter qw(import);
use Scalar::Util qw(blessed);

use Test::EasyMock::MockControl;

our @EXPORT_OK = qw(
    create_mock
    expect
    replay
    reset
    verify
);

sub create_mock {
  my $control = Test::EasyMock::MockControl->create_control(@_);
  return $control->create_mock;
}

sub expect {
  my ($expectation) = @_;
  return __delegate(expect => ($expectation->mock, $expectation));
}
sub replay {
  __delegate(replay => $_) for @_;
}
sub reset {
  __delegate(reset => $_) for @_;
}
sub verify {
  __delegate(verify => $_) for @_;
}

sub __delegate {
  my ($method, $mock, @args) = @_;
  my $control = __control_of($mock)
    or confess('Speocified mock is not under management');
  return $control->$method(@args);
}

sub __control_of {
  my ($mock) = @_;
  my $class = blessed $mock;
  return unless $class && $class eq 'Test::EasyMock::MockObject';
  return $mock->{_control};
}

1;
