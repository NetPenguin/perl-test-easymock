use strict;
use warnings;

use Test::More;
BEGIN {
  use_ok('Test::EasyMock',
         qw{
             create_mock
             expect
             replay
             reset
             verify
             whole
         });
  use_ok('Test::EasyMock::Class',
         qw{
             create_class_mock
         });
}
use Test::Deep qw(ignore);

# ----
# Helper.
sub __suite {
  my ($mock, $target) = @_;
  subtest 'array arguments and array result' => sub {
    my @args = qw(arg1 arg2 arg3);
    my @result = qw(result1 result2 result3);
    expect($mock->foo(@args))->and_array_return(@result);
    replay($mock);

    my @actual = $target->foo(@args);

    is_deeply(\@actual, \@result, 'result');
    verify($mock);
  };

  reset($mock);

  subtest 'named parameter and scalar result' => sub {
    my $args = { arg1 => 1, arg2 => 2, arg3 => 3 };
    my $result = { result1 => 1, result2 => 2, result3 => 3 };
    expect($mock->foo($args))->and_scalar_return($result);
    replay($mock);

    my $actual = $target->foo($args);

    is_deeply($actual, $result, 'result');
    verify($mock);
  };

  reset($mock);

  subtest 'with Test::Deep comparison parameter' => sub {
    my $result1 = 'a result of first.';
    my $result2 = 'a result of sencond.';
    my $result3 = 'a result of third.';
    expect($mock->foo( ignore(), ignore() ))->and_scalar_return($result1);
    expect($mock->foo( ignore() ))->and_scalar_return($result2);
    expect($mock->foo( whole(ignore()) ))->and_scalar_return($result3);
    replay($mock);

    my $actual1 = $target->foo(1, 2);
    my $actual2 = $target->foo({ arg1 => 1, arg2 => 2 });
    my $actual3 = $target->foo(1, 2, 3);

    is($actual1, $result1, 'result1');
    is($actual2, $result2, 'result2');
    is($actual3, $result3, 'result3');
    verify($mock);
  };

  reset($mock);

  subtest 'multiple `expect` to same method and argument.' => sub {
    my $args = 'argument';
    my $result1 = 'a result of first.';
    my $result2 = 'a result of second.';

    expect($mock->foo($args))->and_scalar_return($result1);
    expect($mock->foo($args))->and_scalar_return($result2);
    replay($mock);

    my $actual1 = $target->foo($args);
    my $actual2 = $target->foo($args);

    is($actual1, $result1, 'result1');
    is($actual2, $result2, 'result2');
    verify($mock);
  };

  reset($mock);

  subtest 'multiple `expect` to same method and different argument.' => sub {
    my $args1 = 'argument1';
    my $args2 = 'argument2';
    my $result1 = 'a result of first.';
    my $result2 = 'a result of second.';

    expect($mock->foo($args1))->and_scalar_return($result1);
    expect($mock->foo($args2))->and_scalar_return($result2);
    replay($mock);

    my $actual2 = $target->foo($args2);
    my $actual1 = $target->foo($args1);

    is($actual1, $result1, 'result1');
    is($actual2, $result2, 'result2');
    verify($mock);
  };

  reset($mock);

  subtest 'multiple `expect` to different method.' => sub {
    my $args = 'argument';
    my $result1 = 'a result of first.';
    my $result2 = 'a result of second.';

    expect($mock->foo($args))->and_scalar_return($result1);
    expect($mock->bar($args))->and_scalar_return($result2);
    replay($mock);

    my $actual2 = $target->bar($args);
    my $actual1 = $target->foo($args);

    is($actual1, $result1, 'result1');
    is($actual2, $result2, 'result2');
    verify($mock);
  };

  reset($mock);

  subtest 'multiple `and_[scalar|array]_return.' => sub {
    my $args = 'argument';
    my $result1 = 'a result of first';
    my @result2 = qw(a result of second);
    my $result3 = 'a result of third';

    expect($mock->foo($args))
      ->and_scalar_return($result1)
      ->and_array_return(@result2)
      ->and_scalar_return($result3);
    replay($mock);

    my $actual1 = $target->foo($args);
    my @actual2 = $target->foo($args);
    my $actual3 = $target->foo($args);

    is($actual1, $result1, 'result1');
    is_deeply(\@actual2, \@result2, 'result2');
    is($actual3, $result3, 'result3');
    verify($mock);
  };

  reset($mock);

  subtest 'and_stub_scalar_return' => sub {
    my $args1 = 'argument';
    my $result1_1 = 'a result of first.';
    my $result1_2 = 'a result of second.';
    my $args2 = 'other';
    my $result2 = 'a result of other.';

    expect($mock->foo($args1))->and_scalar_return($result1_1);
    expect($mock->foo($args1))->and_stub_scalar_return($result1_2);
    expect($mock->foo($args2))->and_stub_scalar_return($result2);
    replay($mock);

    my $actual1_1 = $target->foo($args1);
    my $actual1_2 = $target->foo($args1);
    my $actual1_3 = $target->foo($args1);
    my $actual2   = $target->foo($args2);

    is($actual1_1, $result1_1, 'result1_1');
    is($actual1_2, $result1_2, 'result1_2');
    is($actual1_3, $result1_2, 'result1_3');
    is(  $actual2,   $result2,   'result2');

    verify($mock);
  };

  reset($mock);

  subtest 'expect with `stub_scalar_return`, but no call mock method.' => sub {
    expect($mock->foo())->and_stub_scalar_return('');
    replay($mock);
    verify($mock); # pass
  };
}

# ----
# Tests.
subtest 'default mock' => sub {
  my $mock = create_mock();
  __suite($mock, $mock);
};

# subtest 'mock class' => sub {
#   my $mock = create_class_mock('Foo');
#   __suite($mock, 'Foo');
# };

# ----
::done_testing;
