package Controller;
use parent WW::Controller;
use WW::CGI;



our @local_rules = (&https_redirect);





sub import
{
	$_ foreach @local_rules;
}





sub https_redirect
{
	unless ( $CGI->{scheme} =~ /https/i ) {
		print STDOUT qq(Status: 301 No, you should use secure connection!\r\n);
		print STDOUT qq(Location: https://$CGI->{host}$CGI->{uri}\r\n\r\n);
		exit;
	}
}














1;
