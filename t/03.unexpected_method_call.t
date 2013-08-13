use strict;
use warnings;

use Test::Tester;
use Test::More;
use List::MoreUtils qw(any all);

my $class;
BEGIN {
  $class = use_ok('Test::EasyMock',
                  qw{
                     create_mock
                     expect
                     replay
                     reset
                     verify
                  });
}

# ----
# Helpers.
sub expect_fail(&;$) {
  my ($code, $name) = @_;
  my ($premature, @results) = run_tests($code);
  ok((any { !$_->{ok} } @results),
     'expect_fail' . (defined $name ? " - $name" : ''));
}
sub expect_pass(&;$) {
  my ($code, $name) = @_;
  my ($premature, @results) = run_tests($code);
  ok((all { $_->{ok} } @results),
     'expect_pass' . (defined $name ? " - $name" : ''));
}

# ----
# Tests.
subtest 'default mock' => sub {
  my $mock = create_mock();

  expect_fail {
    replay($mock);
    $mock->foo();
  } 'nothing is expected.';

  reset($mock);

  expect_fail {
    expect($mock->foo());
    replay($mock);
    $mock->bar();
  } 'expect `foo` method, but `bar` method.';

  reset($mock);
  expect_fail {
    expect($mock->foo());
    replay($mock);
    $mock->foo(1);
  } 'expect empty argument, but an argument exists.';

  reset($mock);
  subtest 'more than the expected times.' => sub {
    expect($mock->foo());
    replay($mock);
    expect_pass { $mock->foo() };
    expect_fail { $mock->foo() };
  };

  reset($mock);
  expect_fail {
    expect($mock->foo());
    replay($mock);
    verify($mock); # fail
  } 'less than the expected times.';
};

# ----
::done_testing;
