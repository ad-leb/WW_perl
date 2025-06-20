package Controller;
use parent WW::Controller;



my @init_tasks = (
	&https_redirect,
);








sub https_redirect
{
	unless ( $WW::env{scheme} =~ /https/i ) {
		print STDOUT qq(Status: 301 No, you should use secure connection!\r\n);
		print STDOUT qq(Location: https://$WW::env{host}$WW::env{uri}\r\n\r\n);
		exit;
	}
}












1;
