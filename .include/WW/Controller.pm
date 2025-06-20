package WW::Controller;
use WW::CGI;
use View;










sub handle
{
	my ($self) = @_;
	my ($pack, $path, $method);

	$pack = $WW::env{uri_space} || q(root);	$pack =~ s/^(\w)/\U$1/;
	$path = $WW::env{uri_path};
	$method = lc $WW::env{method};

	return $pack->$method($path);
}



sub respond
{
	my ($self, $response) = @_;

	print STDOUT map qq($_: $response->{header}{$_}\r\n), keys $response->{header}->%*;
	print STDOUT qq(\r\n);
	print STDOUT $response->{content};
}



















#################################################################
# 						GLOBAL									#
#################################################################




sub UNIVERSAL::AUTOLOAD
{
	my ($pack) = @_;
	my ($sub) = $UNIVERSAL::AUTOLOAD =~ /^.*\:\:(.*)$/;
	my $res;

	our $try++;		print STDERR qq(More than 32 calls of autoload ($pack->$sub). Is it ok?) and exit if $try > 32;

	if ( -e qq($WW::env{root}/.include/App/$pack.pm) ) {
		eval qq(use App::$pack);
		print STDERR qq([$pack\-\>$sub] $@ ($!)) and View->error_500 if $@;
		$res = $pack->$sub or print STDERR qq([$pack->$sub] $@ ($!)) and View->error_500;
	} else {
		print STDERR qq([$pack\-\>$sub] $@ ($!)) and View->error_404;
	}

	$try--;
	return $res;
}
sub UNIVERSAL::DESTROY			{ undef $_[0] }





1;
