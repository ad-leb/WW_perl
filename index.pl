#! /usr/bin/perl
use lib qq($ENV{DOCUMENT_ROOT}/include);
#use lib q(include);
use Html;
use Data::Dumper;



my $head = Html->get_head;
my $body = Html->get_body;


$head->push(Html->meta(q(), charset => q(utf-8)));
$head->unshift(Html->title(q(How is it going?)));

$body->push(Html->h1(q(Hi!), style => q(color: blue)));
$body->push(Html->h1(q(Hi!), style => q(color: green)));
$body->push(Html->h1(q(Hi!), style => q(color: red)));




print qq(Content-Type: text/html\r\n\r\n);
print Html->to_text;








__END__
