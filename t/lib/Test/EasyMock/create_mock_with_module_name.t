use strict;
use warnings;

use FindBin;
use lib "$FindBin::Bin/../../../../lib";

use Test::More;

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
# Helper.

# ----
# Tests.
subtest 'Omit module name.' => sub {
  my $mock = create_mock();
  ok(!$mock->isa('Foo::Bar::Baz'));
};

subtest 'Specify module name.' => sub {
  my $mock = create_mock('Foo::Bar::Baz');
  ok($mock->isa('Foo::Bar::Baz'));
  ok(!$mock->isa('Unknown'));

  reset($mock);

  ok($mock->isa('Foo::Bar::Baz'));
};

# ----
::done_testing();
