use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Test::EasyMock',
    AUTHOR              => 'keita iseki <keita.iseki+cpan@gmail.com>',
    VERSION_FROM        => 'lib/Test/EasyMock.pm',
    ABSTRACT_FROM       => 'lib/Test/EasyMock.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More'    => 0.98,
        'version'       => 0,
	'Carp'          => 0,
	'Data::Dumper'  => 0,
	'Exporter'      => 0,
	'List::Util'    => 0,
	'Scalar::Util'  => 0,
	'Test::Builder' => 0.98,
	'Test::Tester'  => 0.108,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Test-EasyMock-*' },
);
