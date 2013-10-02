use strict;
use warnings;

use Test::More;
BEGIN {
    use_ok('Test::EasyMock',
           qw{
               expect
               replay
               reset
               verify
           });
}
use Test::Exception;

# ----
# Tests.
subtest 'is not a mock object.' => sub {
    my $other = bless {}, '__DUMMY__';
    dies_ok { expect($other) } 'expect';
    dies_ok { replay($other) } 'replay';
    dies_ok { reset($other) } 'reset';
    dies_ok { verify($other) } 'verify';
};

# ----
done_testing;
