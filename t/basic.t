use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new('Mojo::HelloMojo');
$t->get_ok('/')->status_is(404);

done_testing();
