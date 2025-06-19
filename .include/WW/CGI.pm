package WW::CGI;
use WW::Parse;



our $cgi;





sub AUTOLOAD
{ 
 	return $cgi		if ref $cgi and $cgi->isa($_[0]);

	$cgi->{GET} = $_[0]->GET;
	$cgi->{POST} = $_[0]->POST;
	$cgi->{POST_raw} = $_[0]->POST_raw;
	$cgi->{host} = $ENV{HTTP_HOST};
	$cgi->{port} = $ENV{HTTP_X_FORWARDED_PORT} or $ENV{SERVER_PORT};
	$cgi->{scheme} = $ENV{HTTP_X_FORWARDED_PROTO} or $ENV{REQUEST_SCHEME};
	$cgi->{proto} = $ENV{SERVER_PROTOCOL};
	$cgi->{remote_addr} = $ENV{HTTP_X_FORWARDED_ADDR} or $ENV{HTTP_X_REAL_IP} or $ENV{REMOTE_ADDR};
	$cgi->{method} = $ENV{REQUEST_METHOD};
	$cgi->{root} = $ENV{DOCUMENT_ROOT};
	$cgi->{uri} = $ENV{REQUEST_URI};
	$cgi->{query} = $ENV{QUERY_STRING};
	$cgi->{file} = $ENV{SCRIPT_NAME};
	$cgi->{pwd} = ($ENV{SCRIPT_FILENAME} =~ /(.*)\//)[0];
	bless $cgi, $_[0]; 

	return $cgi;
}


sub GET		 						{ WW::Parse::http_urlencoded($ENV{REQUEST_URI}) }
sub POST							{ my @tmp = <STDIN>; my $enctype = ($ENV{CONTENT_TYPE} =~ /(\w+)(;|$)/)[0]; &{qq(WW::Parse::http_$enctype)}(@tmp) if $enctype }
sub POST_raw						{ return join '', <STDIN> }















1;
