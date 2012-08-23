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
                     verify
                  });
}

# ----
# Helper.
sub expect_fail(&;$) {
  my ($code, $name) = @_;
  my ($premature, @results) = run_tests($code);
  ok((any { !$_->{ok} } @results),
     'expect_fail' . (defined $name ? " - $name" : ''));
}

# ----
# Tests.
subtest 'mock to can method' => sub {
    my $mock = create_mock();
    expect($mock->foo)->and_stub_scalar_return('dummy');
    expect($mock->bar)->and_stub_scalar_return('dummy');
    expect($mock->baz)->and_stub_scalar_return('dummy');

    expect($mock->can('foo'))->and_scalar_return(1); # Originally it is code ref
    expect($mock->can('bar'))->and_scalar_return(undef);
    replay($mock);

    is($mock->can('foo'), 1, 'can(foo)');
    is($mock->can('bar'), undef, 'can(bar)');

    expect_fail {
        $mock->can('baz');
    } 'can(baz)';

    verify($mock);
};

# ----
::done_testing;
