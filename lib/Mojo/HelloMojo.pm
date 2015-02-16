package Mojo::HelloMojo;
use Mojolicious::Lite;

our $VERSION  = '0.01';

use Cwd;

app->home(Mojo::Home->new(getcwd));
app->moniker(Mojo::Util::decamelize(app->moniker));

plugin 'Config' => {default => {hello_mojo => ['hello_mojo']}};

foreach my $app_dir ( split(/,/, $ENV{HELLO_MOJO}||'') || @{app->config->{hello_mojo}} ) {
  opendir(my $dh, app->home->rel_dir($app_dir)) or next;
  foreach ( grep { !/^\./ } readdir($dh) ) {
    my $app;

    # Create a directory by the name of your lite_app
    # Change to that directory, then generate your lite_app by the same name
    $app = app->home->rel_file("$app_dir/$_/$_.pl");
    $app = app->home->rel_file("$app_dir/$_/$_") unless $app && -f $app;

    $app = app->home->rel_file("$app_dir/$_/script/$_") unless $app && -f $app;
    $app = app->home->rel_file("$app_dir/$_/script/$_.pl") unless $app && -f $app;

    if ( -f "$app_dir/$_/.nomojo" ) {
      app->log->info("No Mojo for $app, skipping");
    } elsif ( $app && -f $app ) {
      plugin Mount => {"/$_" => $app};
      app->log->info("Mounted /$_ => $app");
    } else {
      app->log->info("No start script found for $app, skipping");
    }
  }
  closedir $dh;
}

1;

=encoding utf8

=head1 NAME

Mojo::HelloMojo - Mount All full and lite apps!

=head1 SYNOPSIS

  use Mojo::HelloMojo;

  my $hello = Mojo::HelloMojo->new;
  $hello->start;

=head1 DESCRIPTION

L<Mojo::HelloMojo> is a L<Mojolicious> application.

=head1 SEE ALSO

L<Mojolicious>, L<Mojolicious::Guides>, L<http://mojolicio.us>.

=cut
