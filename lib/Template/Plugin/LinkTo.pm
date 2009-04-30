package Template::Plugin::LinkTo;
use strict;
use warnings;

use parent 'Template::Plugin';
use URI::Escape;

our $VERSION = '0.03';

my @HTML_OPTIONS = qw/href target confirm/;

sub link_to {
    my ($self, $text, $opt) = @_;
    $text = uri_escape $text;

    my $result = $text;

    if (my $href = $opt->{href}) {
        my $target  = $opt->{target} ? qq{target="$opt->{target}"} : '';
        my $confirm = $opt->{confirm} ? qq{onclick="return confirm('$opt->{confirm}');"} : ''; #"
        $result = qq{<a href="$href" $target $confirm>$text</a>};

        for my $key (@HTML_OPTIONS) {
            delete $opt->{$key};
        }
        
        my $params;
        for my $key (keys %$opt) {
            $params .= qq{&$key=$opt->{$key}};
        }
        if ($params) {
            $href .= $params;
            $href  =~ s{&}{?}
                if $href !~ m{\?};
        }

        $result = qq{<a href="$href" $target $confirm>$text</a>};
        $result =~ s{\s{2,}}{};
        $result =~ s{\s>}{>};
    }

    return $result;
}

1;


__END__
=head1 NAME

Template::Plugin::LinkTo - like link_to in Ruby on Rails

=head1 SYNOPSIS

Input:

  [% USE LinkTo -%]
  [% args = {
      href => '/link/to',
  } -%]
  [% LinkTo.link_to('link_text', args) %]

Output:

  <a href="/link/to">link_text</a>

Input:

  [% USE LinkTo -%]
  [% args = {
      href => '/link/to',
      hoge => 'huga',
      foo  => 'bar',
  } -%]
  [% LinkTo.link_to('link_text', args) %]

Output:

  <a href="/link/to?foo=bar&hoge=huga">link_text</a>

Input:

  [% USE LinkTo -%]
  [% args = {
      href   => '/link/to',
      hoge   => 'huga',
      target => '_blank',
  } -%]
  [% LinkTo.link_to('link_text', args) %]

Output:

  <a href="/link/to?hoge=huga" target="_blank">link_text</a>

Input:

  [% USE LinkTo -%]
  [% args = {
      href    => '/link/to',
      hoge    => 'huga',
      target  => '_blank',
      confirm => 'really ?',
  } -%]
  [% LinkTo.link_to('link_<br />text', args) %]

Output:

  <a href="/link/to?hoge=huga" target="_blank" onclick="return confirm('really ?');">link_%3Cbr%20%2F%3Etext</a>

Input:

  [% USE LinkTo -%]
  [% args = {
  } -%]
  [% LinkTo.link_to('link_text', args) %]

Output:

  link_text


=head2 Sample with DBIx::Class::ResultSet

  [% USE LinkTo -%]
  [%- WHILE (u = users.next) -%]
  [% args = {
      href => "user/${u.id}",
      hoge => 'huga',
      foo  => 'bar',
  } -%]
  [% LinkTo.link_to(u.nickname, args) %]
  [%- END %]
 

=head1 DESCRIPTION

Template::Plugin::LinkTo is like link_to in Ruby on Rails, but NOT same at all.

=head1 SEE ALSO

L<Template>, L<Template::Plugin>

=head1 AUTHOR

Tomoya Hirano, E<lt>hirafoo@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

This library is free software; you can redistribute it and/or modify

=cut
