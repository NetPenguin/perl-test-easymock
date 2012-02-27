package Test::EasyMock::MockObject;
use strict;
use warnings;

# Override
sub isa {
    # TODO: expect 時の引数に eq や not(eq(...)) を使えるようになり次第
    #       and_stub_return として定義する
    my ($self, $module) = @_;
    return unless $module;

    my $self_module = $self->{_control}->{_module};
    return unless $self_module;

    return $module eq $self_module;
}

sub AUTOLOAD {
    our $AUTOLOAD;
    my $self = shift;
    my ($sub) = do {
        local $1;
        $AUTOLOAD =~ m{::(\w+)\z}xms;
    };
    return if $sub eq 'DESTROY';
    return $self->{_control}->process_method_invocation($self, $sub, @_);
}

1;
