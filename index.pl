#! /usr/bin/perl
use lib qq($ENV{DOCUMENT_ROOT}/include);
use View::First;






my ($page, $content) = View::First->new;


$content->push(
	$page->h2(q(Hey!), style=>q(color: #333)),
	$page->br,
	$page->p(q(What's up?), style=>q(color: #888)),
	$page->img(src=>q(/res/pic/0.png), style=>q(width: 45vmax), title=>q(manga 'City', Arawi Keiichi), async=>0),
);








print qq(Content-Type: text/html\r\n\r\n);
print STDOUT $page->to_text;








__END__
