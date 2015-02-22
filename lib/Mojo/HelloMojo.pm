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
    my $app = find_script($app_dir => $_);
    if ( -f $app_dir->rel_file("$_/.nomojo") ) {
      app->log->info("No Mojo for $app, skipping");
    } elsif ( $app && -f $app ) {
      my $mount = plugin Mount => {"/$_" => $app};
      app->log->info("Mounted /$_ => $app");
      if ( my $domain = $mount->pattern->defaults->{app}->config('domain') ) {
        foreach my $d ( ref $domain eq 'ARRAY' ? @$domain : $domain ) {
          my $mount = plugin Mount => {$d => $app};
          app->log->info("Mounted $d => $app");
        }
      }
    } else {
      app->log->info("No start script found for $app, skipping");
    }
  }
  closedir $dh;
}

sub find_script {
  my ($app_dir, $app_name) = @_;
  my $dashes = my $us = $app_name;
  $dashes =~ s/_/-/g;
  $us =~ s/-/_/g;
  my $app;
  foreach ( $app_name, $dashes, $us ) {
    $app = $app_dir->rel_file("$app_name/$_.pl") and -f $app and return $app;
    $app = $app_dir->rel_file("$app_name/$_") and -f $app and return $app;
    $app = $app_dir->rel_file("$app_name/script/$_") and -f $app and return $app;
    $app = $app_dir->rel_file("$app_name/script/$_.pl") and -f $app and return $app;
  }
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
