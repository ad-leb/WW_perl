package WW::CGI;
use WW::Parse;





sub import 
{
	$_[0]->fill_WW;
}
sub DESTROY						{ undef $cgi }


sub fill_WW
{
	$WW::env{GET} = $_[0]->GET;
	$WW::env{POST_raw} = $_[0]->POST_raw;
	$WW::env{POST} = $_[0]->POST;
	$WW::env{COOKIE} = $_[0]->COOKIE;
	$WW::env{host} = $ENV{HTTP_HOST};
	$WW::env{port} = $ENV{HTTP_X_FORWARDED_PORT} || $ENV{SERVER_PORT};
	$WW::env{scheme} = $ENV{HTTP_X_FORWARDED_PROTO} || $ENV{REQUEST_SCHEME};
	$WW::env{proto} = $ENV{SERVER_PROTOCOL};
	$WW::env{remote_addr} = $ENV{HTTP_X_FORWARDED_ADDR} || $ENV{HTTP_X_REAL_IP} || $ENV{REMOTE_ADDR};
	$WW::env{method} = $ENV{REQUEST_METHOD};
	$WW::env{root} = $ENV{DOCUMENT_ROOT};
	$WW::env{uri} = $ENV{REQUEST_URI};
	$WW::env{query} = $ENV{QUERY_STRING};
	$WW::env{file} = $ENV{SCRIPT_NAME};

	$WW::env{pwd} = ($ENV{SCRIPT_FILENAME} =~ /(.*)\//)[0];
	($WW::env{uri_space}, $WW::env{uri_path}) = ($ENV{REQUEST_URI} =~ /^\/([\w\-]+)\/?(.*)\/?$/);

	$WW::env{session} = $WW::env{COOKIE}{session};
}


sub GET		 					{ WW::Parse::http_urlencoded($ENV{REQUEST_URI}) }
sub POST_raw					{ return join '', <STDIN> }
sub POST						{ my @tmp = $WW::env{POST_raw}; my $enctype = ($ENV{CONTENT_TYPE} =~ /(\w+)(;|$)/)[0]; &{qq(WW::Parse::http_$enctype)}(@tmp) if $enctype }
sub COOKIE						{ WW::Parse::http_urlencoded($ENV{COOKIE}) }















1;
