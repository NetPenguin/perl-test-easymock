use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Test::EasyMock',
    license             => 'perl',
    dist_author         => 'keita iseki <keita.iseki+cpan@gmail.com>',
    dist_version_from   => 'lib/Test/EasyMock.pm',
    requires => {
        'Test::More'    => 0,
        'version'       => 0,
	'Carp'          => 0,
	'Data::Dumper'  => 0,
	'Exporter'      => 0,
	'List::Util'    => 0,
	'Scalar::Util'  => 0,
	'Test::Builder' => 0,
    },
    add_to_cleanup      => [ 'Test-EasyMock-*' ],
);

$builder->create_build_script();
