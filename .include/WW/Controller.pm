package WW::Controller;
use WW::CGI;
use View;










sub handle
{
	my ($self) = @_;
	my ($pack, $path, $method);

	$pack = $CGI->{uri_space} || q(root);	$pack =~ s/^(\w)/\U$1/;
	$path = $CGI->{uri_path};
	$method = lc $CGI->{method};

	return &{$method}($pack, $path, $method);
}



sub respond
{
	my ($self, $response) = @_;

	print STDOUT map qq($_: $response->{header}{$_}\r\n), keys $response->{header}->%*;
	print STDOUT qq(\r\n);
	print STDOUT $response->{content};
}




sub get
{
	my ($pack, $path, $method) = @_;
	my ($page, $content, $text);

	$content = $pack->$method($path);
	$page = View->new($content);
	$text = $page->to_text;

	return { 
		header 					=> {
			q(Status) 			=> q[200 OK :)], 
			q(Content-Type) 	=> q(text/html; charset=utf-8),
		},
		content 				=> $text,
	};
}
sub post
{
	return {
		header 					=> {
			q(Status) 			=> q[204 Still working on it..], 
			q(Content-Type) 	=> q(text/plain; charset=utf-8),
		},
		content 				=> qq(Bada-boom\n),
	};
}














sub UNIVERSAL::AUTOLOAD
{
	our $try++;		print STDERR q(More than 32 calls of autoload. Is it ok?) and View->error_500 if $try > 32;

	my ($pack) = @_;
	my ($sub) = $UNIVERSAL::AUTOLOAD =~ /^.*\:\:(.*)$/;
	my $res;

	eval qq(use App::$pack);			
	View->error_404 if $@;

	$res = $pack->$sub or View->error_500;

	$try--;
	return $res;
}
sub UNIVERSAL::DESTROY			{ undef $ref }



1;
