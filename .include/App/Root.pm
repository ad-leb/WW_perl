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

	return q(Hello! It's a root page);
}









1;
