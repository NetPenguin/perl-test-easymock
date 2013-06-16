requires 'perl', '5.008001';

requires 'Carp';
requires 'Data::Dumper';
requires 'Exporter';
requires 'List::Util';
requires 'List::MoreUtils';
requires 'Scalar::Util';
requires 'Test::Builder'   => '0.98';
requires 'Test::More'      => '0.98';

on 'test' => sub {
    requires 'Test::More'          => '0.98';
    requires 'Test::Tester'        => '0.108';
    requires 'Test::Perl::Critic'  => '1.02';
    requires 'Test::Pod'           => '1.14';
    requires 'Test::Pod::Coverage' => '1.04';
};
