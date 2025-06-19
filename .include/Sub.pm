package Sub;
use WW::CGI;
use WW::DB;


our $AUTOLOAD;





sub AUTOLOAD
{
	my ($self) = @_;
	my ($req) = $AUTOLOAD =~ /.*::(.*)$/;
	my $content;


	if ( $CGI->{uri_sub} ) {
		push $content->@*, eval { do qq($CGI->{root}/sub/$CGI->{uri_sub}.pl) };
	} else {
		$content = (WW::DB->get_article_by_id({id => 1}))->{1}{content};
	}


	my $page = View->new($content);

	print STDOUT qq(Content-Type: text/html\r\n\r\n);
	print STDOUT $page->to_text;
}















1;
