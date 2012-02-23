package Test::EasyMock::MockObject;
use strict;
use warnings;

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
