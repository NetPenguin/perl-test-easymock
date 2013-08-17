use strict;
use warnings;

use t::Util qw(expect_fail);
use Test::More;
BEGIN {
    use_ok('Test::EasyMock', qw(:all));
    use_ok('Test::EasyMock::Class', qw(create_class_mock));
}
use t::Foo;

# ----
# Helper.

# ----
# Tests.
subtest 'mock class method.' => sub {
    my $mock = create_class_mock('t::Foo');

    subtest 'expected method call' => sub {
        expect($mock->foo(1))->and_scalar_return('a');
        replay($mock);
        is(t::Foo->foo(1), 'a', 'result');
        verify($mock);
    };

    reset($mock);

    subtest 'unexpected method call' => sub {
        expect($mock->foo(1))->and_stub_scalar_return('a');
        replay($mock);
        expect_fail { t::Foo->foo(2) } 'unexpected method call.';
        verify($mock);
    };

    reset($mock);

    subtest 'not mocked method call' => sub {
        expect($mock->foo(1))->and_stub_scalar_return('a');
        replay($mock);
        is(t::Foo->bar(1), 'original-bar', 'result');
        verify($mock);
    };

    reset($mock);

    subtest 'after reset' => sub {
        expect($mock->foo(1))->and_stub_scalar_return('a');
        replay($mock);
        reset($mock);
        is(t::Foo->foo(1), 'original-foo', 'result');
    };

    reset($mock);

    subtest 'after gc' => sub {
        {
            expect($mock->foo(1))->and_stub_scalar_return('a');
            replay($mock);
            my $control = $mock->{_control};
            my $x = $mock;
            use Scalar::Util qw(weaken isweak);
            weaken($control);
            weaken($x);
            warn "BEFORE: CONTROL: $control";
            $mock = undef;
            undef($mock);
            warn "AFTER: CONTROL: $control";
            warn "AFTER: MOCK: $x\n", isweak($x);
            use Data::Dumper; warn Dumper($x);
        }
        is(t::Foo->foo(1), 'original-foo', 'result');
    };
};

# ----
done_testing;
