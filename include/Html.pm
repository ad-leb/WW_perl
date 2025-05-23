package Html;
use parent Xml;




our $AUTOLOAD;
our $base = [
	{
		_name					=> q(!DOCTYPE),
		_single					=> 1,
		html					=> q(),
	},
	{
		_name					=> q(html),
		_single					=> 0,
		_content				=> [
		{
			_name				=> q(head),
			_single				=> 0,
			_content			=> [],
		},
		{
			_name				=> q(body),
			_single				=> 0,
			_content			=> [],
		},
		],
	},
];
our @single_tag = qw(
	!DOCTYPE
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
	my ($self, $content, %param) = @_;
	my $name = ($AUTOLOAD =~ /.*::(.*)$/)[0];
	my $req = qq(SUPER::$name);

	$param{_single}++ if grep /$name/, @single_tag;

	$self->$req($content, %param);
}






sub get_page									{ bless $base, $_[0] }
sub get_head									{ bless $base->[1]{_content}[0], $_[0] }
sub get_body									{ bless $base->[1]{_content}[1], $_[0] }

sub to_text										{ _to_text($_[0]->get_page) }














1;
