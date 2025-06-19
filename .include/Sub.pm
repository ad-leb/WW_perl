package Sub;
use JSON;
use Data::Dumper;
use WW::CGI;
use WW::DB;


our $AUTOLOAD;
our $cgi = WW::CGI->new;





sub AUTOLOAD
{
	my ($self) = @_;
	my ($req) = $AUTOLOAD =~ /.*::(.*)$/;
	my $content;


	if ( $cgi->{uri} =~ /^\/auth\/?/ ) {
		my $res = eval { do qq($cgi->{root}/sub/auth.pl) };
		$content = $res;
	} else {
		$content = (WW::DB->get_article_by_id({id => 1}))->{1}{content};
	}


	my $page = View->new([$content]);

	print STDOUT qq(Content-Type: text/html\r\n\r\n);
	print STDOUT $page->to_text;
}















1;
