package WW::Controller;
use WW;










sub do_cycle
{
	my ($self, $view) = @_;

	$WW::view = $view;

	Controller->handle;
	Controller->respond;
}





sub handle
{
	my ($self) = @_;
	my ($pack, $path, $method);

	$pack = $WW::env{uri_space} || q(root);	$pack =~ s/^(\w)/\U$1/;
	$path = $WW::env{uri_path};
	$method = lc $WW::env{method};

	$WW::response = $pack->$method($path);
}



sub respond
{
	my ($self) = @_;

	$WW::view->wrap($WW::response);

	print STDOUT qq(Status: $WW::response->{status} $WW::str->{$WW::response->{status}}{http}\r\n);
	print STDOUT map qq($_: $WW::response->{header}{$_}\r\n), keys $WW::response->{header}->%*;
	print STDOUT qq(\r\n);
	print STDOUT $WW::response->{content};
}



sub error
{
	my ($self, $status) = @_;

	$WW::response = {
		status					=> $status,
		header					=> {
			q(Content-Type)		=> q(text/html; charset=utf-8),
		},
		content					=> [ $WW::view->hr, $WW::view->h4(qq($WW::str->{$status}{html})), $WW::view->hr ],
	};

	&respond;
	exit;
}

















#################################################################
# 						GLOBAL									#
#################################################################




sub UNIVERSAL::AUTOLOAD
{
	my ($pack) = @_;
	my ($sub) = $UNIVERSAL::AUTOLOAD =~ /^.*\:\:(.*)$/;
	my $res;

	our $try++;		print STDERR qq(More than 32 calls of autoload ($pack->$sub). Is it ok?) and return WW::Controller->error(500) if $try > 32;

	if ( -e qq($WW::env{root}/.include/App/$pack.pm) ) {
		eval qq(use App::$pack);
		print STDERR qq([$pack\-\>$sub] $@ ($!)) and return WW::Controller->error(500) if $@ =~ /\w/;
		$res = $pack->$sub 
			or print STDERR qq([$pack->$sub] $@ ($!)) and return WW::Controller->error(500);
	} else {
		print STDERR qq([$pack\-\>$sub] $@ ($!)) and return WW::Controller->error(404);
	}

	$try--;
	return $res;
}
sub UNIVERSAL::DESTROY			{ undef $_[0] }





1;
