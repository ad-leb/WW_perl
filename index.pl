#! /usr/bin/perl
use lib qq($ENV{DOCUMENT_ROOT}/include);
use View::First;






my ($html, $head, $body) = View::First->new;

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


$body->push($html->form([{label=>q(<b>Попсон:</b> ), name=>q(pop), value=>q(Hi), type=>q(text)}]));






print qq(Content-Type: text/html\r\n\r\n);
print STDOUT $html->to_text;








__END__
