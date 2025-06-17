package WW::Html;
use parent WW::Xml;




our $AUTOLOAD;
our @single_tag = qw(
	DOCTYPE
	area
	base
	basefont
	bgsound
	br
	col
	command
	embed
	hr
	img
	input
	isindex
	keygen
	link
	meta
	param
	source
	track
	wbr
);








sub AUTOLOAD
{
	my $self = shift;
	my $content = shift if @_ % 2;
	my %param = @_;
	my $name = ($AUTOLOAD =~ /.*::(.*)$/)[0];
	my $req = qq(SUPER::$name);

	$param{_single}++ if grep /^$name$/, @single_tag;

	$content 
		? $self->$req($content, %param)
		: $self->$req(%param)
	;
}






sub page
{ 
	my $page = $_[0]->_([
		$_[0]->DOCTYPE(0, html=>0),
		$_[0]->html([
			$_[0]->head,
			$_[0]->body
		])
	]);
	my $head = $page->head, 
	my $body = $page->body;

	return $page, $head, $body;
}
sub head										{ (ref $_[0]) ? $_[0]->{_content}[1]{_content}[0] : $_[0]->SUPER::head }
sub body										{ (ref $_[0]) ? $_[0]->{_content}[1]{_content}[1] : $_[0]->SUPER::body }




sub get
{
	my $this = shift;
	my $name = shift if @_ % 2;
	my %param = @_;

	$name =~ /^#(.*)$/
		and $param{id} = $1
		and undef $name
	or $name =~ /^\.(.*)$/
		and $param{class} = $1
		and undef $name
	;

	return ($name) ? $this->SUPER::get($name, %param) : $this->SUPER::get(%param);
}















1;
