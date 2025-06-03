#! /usr/bin/perl
use lib qq($ENV{DOCUMENT_ROOT}/include);
use View::First;






my $page = View::First->new;

$page->push(
	$page->header,
	$page->main,
	$page->footer
);






print qq(Content-Type: text/html\r\n\r\n);
print STDOUT $page->to_text;








__END__
