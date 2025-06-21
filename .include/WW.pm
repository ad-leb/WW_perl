package WW;
use WW::Parse;
use WW::DB;
use WW::View;
use WW::Controller;



our $str = {
	200						=> { 
		http				=> q[Ok :)],
	},
	202						=> {
		http				=> q(Ok. Here's only a raw data, no HTML),
	},
	204						=> {
		http				=> q(No content. Working on it :s),
		html				=> q(Sorry, still working on it),
	},
	404						=> {
		http				=> q(Here's no that action, dude),
		html				=> q(HTTP 404: Here's no that page, dude),
	},
	500						=> {
		http				=> q(Sorry, something's wrong),
		html				=> q(HTTP 500: Wow, got an error..),
	},
};
our %env = (
	GET						=> WW->GET,
	POST_raw				=> WW->POST_raw,
	COOKIE					=> WW->COOKIE,

	host					=> $ENV{HTTP_HOST},
	port					=> ($ENV{HTTP_X_FORWARDED_PORT} || $ENV{SERVER_PORT}),
	scheme					=> ($ENV{HTTP_X_FORWARDED_PROTO} || $ENV{REQUEST_SCHEME}),
	proto					=> $ENV{SERVER_PROTOCOL},
	remote_addr				=> ($ENV{HTTP_X_FORWARDED_ADDR} || $ENV{HTTP_X_REAL_IP} || $ENV{REMOTE_ADDR}),
	method					=> $ENV{REQUEST_METHOD},
	root					=> $ENV{DOCUMENT_ROOT},
	uri						=> $ENV{REQUEST_URI},
	query					=> $ENV{QUERY_STRING},
	file					=> $ENV{SCRIPT_NAME},

	pwd						=> ($ENV{SCRIPT_FILENAME} =~ /(.*)\//)[0],
	uri_space				=> ($ENV{REQUEST_URI} =~ /^\/([\w\-]+)/)[0] || q(), 
	uri_path				=> ($ENV{REQUEST_URI} =~ /^\/[\w\-]+\/?(.*)\/?$/)[0] || q(),

	session					=> $env{COOKIE}{session},

	user					=> $WW::model->{user},
);
our $view;
our $model;
our $response = {
	status					=> 500,
	header					=> {},
	meta					=> [],
	content					=> [],
};





sub import						{ $env{POST} = $_[0]->POST }
sub DESTROY						{ undef $cgi }



sub GET		 					{ WW::Parse::http_urlencoded($ENV{REQUEST_URI}) }
sub POST_raw					{ return join q(), <STDIN> }
sub POST						{ my $tmp = $WW::env{POST_raw}; my $enctype = ($ENV{CONTENT_TYPE} =~ /(\w+)(;|$)/)[0]; &{qq(WW::Parse::http_$enctype)}($tmp) if $enctype }
sub COOKIE						{ WW::Parse::http_cookie($ENV{COOKIE}) }















1;
