#! /usr/bin/perl
use lib qq($ENV{DOCUMENT_ROOT}/include);
#use lib q(include);
use Html;
#use Data::Dumper;



my ($html, $head, $body) = Html->page;

$head->push(
	Html->meta(0, charset => q(utf-8))
);
$body->push(
	Html->hr,
	Html->h2(
		q(Привет!), 
		style => q(color: green)
	),
	Html->hr
);





print qq(Content-Type: text/html\r\n\r\n);
print STDOUT $html->to_text;








__END__
