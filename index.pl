#! /usr/bin/perl
#use lib qq($ENV{DOCUMENT_ROOT}/include);
use lib q(include);
use View::First;






my $page = View::First->new;

$page->set(
	$page->meta(
		q(),
		charset => q(utf-8)
	)
);
$page->push(
	$page->hr,
	$page->h2(
		q(Привет!), 
		style => q(color: green)
	),
	$page->hr
);


$page->push(
	$page->form([
			{ label=>q(<b>Попсон:</b> ), name=>q(pop), value=>q(Hi), type=>q(text) },
			{ label=>q(<b>Соспсон:</b> ), name=>q(opo), value=>q(Bye), type=>q(text) },
			{ label=>q(<b>Опсон:</b> ), name=>q(oop), value=>200000, type=>q(range) },
	]),
	$page->hr
);






print qq(Content-Type: text/html\r\n\r\n);
print STDOUT $page->to_text;








__END__
