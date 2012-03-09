package Test::EasyMock;
use strict;
use warnings;
use version; our $VERSION = '0.01';

=head1 NAME

Test::EasyMock - A mock library which is usable easily.

=head1 SYNOPSIS

    use Test::EasyMock qw(
        create_mock
        expect
        replay
        verify
        reset
    );
    
    my $mock = create_mock();
    expect($mock->foo(1))->and_scalar_return('a');
    expect($mock->foo(2))->and_scalar_return('b');
    replay($mock);
    $mock->foo(1); # return 'a'
    $mock->foo(2); # return 'b'
    $mock->foo(3); # Unexpected method call.(A test is failed)
    verify($mock); # verify all expectations is invoked.
    
    reset($mock);
    expect($mock->foo(1, 2)->and_array_return('a', 'b');
    expect($mock->foo({ value => 3 })->and_array_return('c');
    replay($mock);
    $mock->foo(1, 2); # return ('a', 'b')
    $mock->foo({ value => 3 }); # return ('c')
    verify($mock);
    
    reset($mock);
    expect($mock->foo(1))->and_scalar_return('a');
    expect($mock->foo(1))->and_scalar_return('b');
    replay($mock);
    $mock->foo(1); # return 'a'
    $mock->foo(1); # return 'b'
    $mock->foo(1); # Unexpected method call.(A test is failed)
    verify($mock);

=head1 DESCRIPTION

This is mock library modeled on 'EasyMock' in Java.

=cut
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

=head1 FUNCTIONS

=head2 create_mock([$module_name])

Creates a mock object.
If specified the I<$module_name> then a I<isa($module_name)> method of the mock object returns true.

=cut
sub create_mock {
    my $control = Test::EasyMock::MockControl->create_control(@_);
    return $control->create_mock;
}

=head2 expect($expectation)

Record a method invocation and behavior.

The following example is expecting the I<foo> method invocation with I<$arguments>
and a result of the invocation is I<123>.

    expect($mock->foo($arguments))
        ->and_scalar_return(123);

And the next example is expecting the I<foo> method invocation without an argument
and a result of the invocation is I<(1, 2, 3)>.

    expect($mock->foo())
        ->and_array_return(1, 2, 3);

=head3 A list of I<and_*> methods.

=over

=item and_scalar_return($value)

Add scalar result to the expectation.

=item and_array_return(@values)

Add array result to the expectation.

=item and_die([$message])

Add I<die> behavior to the expectation.

=item and_stub_scalar_return($value)

Set scalar result as a stub to the expectation.

=item and_stub_array_return(@values)

Set array result as a stub to the expectation.

=item and_stub_die([$message])

Set I<die> behavior as as stub to the expectation.

=back

=cut
sub expect {
    my ($expectation) = @_;
    return __delegate(expect => ($expectation->mock, $expectation));
}

=head2 replay($mock [, $mock2 ...])

Replay the mock object behaviors which is recorded by the I<expect> function.

    replay($mock);

=cut
sub replay {
    __delegate(replay => $_) for @_;
}

=head2 verify($mock)

Verify the mock method invocations.

=cut
sub verify {
    __delegate(verify => $_) for @_;
}

=head2 reset($mock)

Reset the mock.

=cut
sub reset {
    __delegate(reset => $_) for @_;
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
__END__

=head1 AUTHOR

keita iseki C<< <keita.iseki+cpan at gmail.com> >>

=head1 LICENCE AND COPYRIGHT

Copyright (c) 2012, keita iseki C<< <keita.iseki+cpan at gmail.com> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.

=head1 SEE ALSO

=over

=item EasyMock

L<http://easymock.org/>

It is a very wonderful library for the Java of a mock object.

=back

=cut
