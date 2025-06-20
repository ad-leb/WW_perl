package Root;




sub _root
{
	my $content = View->new(q(Hi! What's up?));

	print STDOUT qq(Content-Type: text/html\r\n\r\n);
	print STDOUT $content->to_text;
}


sub get
{
	my ($self, $path) = @_;

	return {
		header					=> {
			q(Status)			=> q[200 Ok :)],
			q(Content-Type)		=> q(text/html; charset=utf-8),
		},
		meta					=> [
			View->title(q(Главная страница)),
			View->link(rel => q(stylesheet), href => q(test_link)),
		],
		content					=> q(Hello! It's a root page),
	};
}









1;
