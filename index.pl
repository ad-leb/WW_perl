#! /usr/bin/perl
use lib qq($ENV{DOCUMENT_ROOT}/include);
use View::First;






my $page = View::First->new;

$page->push(
	$page->header,
	$page->main,
	$page->footer
);

map { $_->{href} = q(/BIG_POPSON) } $page->get(href=>q(/pops));

my ($where) = $page->get(_content=>q(right));
$where->{_content} =~ s/right/left/g;






print qq(Content-Type: text/html\r\n\r\n);
print STDOUT $page->to_text;








__END__
