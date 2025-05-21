package Html;

use constant SINGLE				=> 0;
use constant DOUBLE				=> 1;




our $AUTOLOAD;
our $base = [
	{
		_type					=> SINGLE,
		_name					=> q(!DOCTYPE),
		html					=> q(),
	},
	{
		_type					=> DOUBLE,
		_name					=> q(html),
		_content				=> [
		{
			_type				=> DOUBLE,
			_name				=> q(head),
			_content			=> [],
		},
		{
			_type				=> DOUBLE,
			_name				=> q(body),
			_content			=> [],
		},
		],
	},
];





sub AUTOLOAD
{
	my ($self, $content, %param) = @_;
	my ($class, $name) = ($AUTOLOAD =~ /(.*)::(.*)$/);
	my $type = ($content) ? DOUBLE : SINGLE;
	my $obj;

	$obj->{_type} = $type;
	$obj->{_name} = $name;
	$obj->{_content} = $content;
	$obj->{$_} = $param{$_} foreach (keys %param);

	bless $obj, $class;
}
sub DESTROY
{
	my ($this) = @_;

	undef $this;
}



sub get_page									{ bless $base, $_[0] }
sub get_head									{ bless $base->[1]{_content}[0], $_[0] }
sub get_body									{ bless $base->[1]{_content}[1], $_[0] }

sub push										{ push $_[0]->{_content}->@*, $_[1] }
sub pop											{ pop $_[0]->{_content}->@*, $_[1] }
sub unshift										{ unshift $_[0]->{_content}->@*, $_[1] }
sub shift										{ shift $_[0]->{_content}->@*, $_[1] }

sub to_text										{ _to_text($_[0]->get_page) }




sub _to_text
{
	my ($obj) = @_;
	my $txt;

	return $obj if !ref $obj;
	foreach my $el ($obj->@*)
	{
		$txt .= qq(<$el->{_name});
		map {
			$txt .= qq( $_);
			$el->{$_} and $txt .= qq(="$el->{$_}")
		} grep /^[a-zA-Z]/, keys $el->%*;
		$txt .= q(>);
		if ( $el->{_type} == DOUBLE ) {
			$txt .= _to_text($el->{_content});
			$txt .= qq(</$el->{_name}>);
		}
	}

	return $txt;
}














1;
