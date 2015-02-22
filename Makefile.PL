use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
  NAME         => 'Mojo::HelloMojo',
  VERSION_FROM => 'lib/Mojo/HelloMojo.pm',
  ABSTRACT     => 'Mount all apps',
  AUTHOR       => 'Stefan Adams <stefan@borgia.com>',
  LICENSE      => 'artistic_2',
  EXE_FILES    => ['script/hello_mojo'],
  PREREQ_PM    => {'Mojolicious' => '5.80'},
  test         => {TESTS => 't/*.t'}
);
