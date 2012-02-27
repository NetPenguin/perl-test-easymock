package Test::EasyMock::MockObject;
use strict;
use warnings;

# Override
sub isa {
    # TODO: expect $B;~$N0z?t$K(B eq $B$d(B not(eq(...)) $B$r;H$($k$h$&$K$J$j<!Bh(B
    #       and_stub_return $B$H$7$FDj5A$9$k(B
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
