use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

use FindBin;

foreach ( "$FindBin::Bin/hello_mojo", "hello_mojo" ) {
  $ENV{HELLO_MOJO} = $_;
  my $t = Test::Mojo->new('Mojo::HelloMojo');
  $t->get_ok('/')->status_is(404);
  $t->get_ok('/my_app')->status_is(200);
  $t->get_ok('/myapp')->status_is(200);
}

done_testing();
