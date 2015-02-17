package Mojo::HelloMojo;
use Mojolicious::Lite;

our $VERSION  = '0.03';

use Cwd;

app->moniker(Mojo::Util::decamelize(app->moniker));

plugin 'Config' => {default => {hello_mojo => ['.']}};

foreach my $app_dir ( $ENV{HELLO_MOJO} ? split /:/, $ENV{HELLO_MOJO} : @{app->config->{hello_mojo}} ) {
  $app_dir = Mojo::Path->new($app_dir)->leading_slash ? Mojo::Home->new($app_dir) : Mojo::Home->new(Mojo::Path->new(getcwd)->trailing_slash(1)->merge($app_dir));
  opendir(my $dh, $app_dir) or next;
  foreach ( grep { !/^\./ } readdir($dh) ) {
    my $app;
    # Create a directory by the name of your lite_app
    # Change to that directory, then generate your lite_app by the same name
    $app = $app_dir->rel_file("$_/$_.pl");
    $app = $app_dir->rel_file("$_/$_") unless $app && -f $app;

    $app = $app_dir->rel_file("$_/script/$_") unless $app && -f $app;
    $app = $app_dir->rel_file("$_/script/$_.pl") unless $app && -f $app;

    if ( -f $app_dir->rel_file("$_/.nomojo") ) {
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
