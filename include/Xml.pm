package Xml;
use Data::Dumper;



our $AUTOLOAD;






sub AUTOLOAD
{
	my ($self, $content, %param) = @_;
	my $name = ($AUTOLOAD =~ /.*::(.*)$/)[0];
	my $single = 0;
	my $obj;

	$obj->{_single} = $single;
	$obj->{_name} = $name;
	$obj->{_content} = $content;
	$obj->{$_} = $param{$_} foreach (keys %param);

	bless $obj, $self;
}
sub DESTROY
{
	my ($this) = @_;

	undef $this;
}



sub push										{ my $this = shift; push $this->{_content}->@*, @_ }
sub pop											{ pop $_[0]->{_content}->@* }
sub unshift										{ my $this = shift; unshift $this->{_content}->@*, @_ }
sub shift										{ shift $_[0]->{_content}->@* }





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

		next if ( $el->{_single} );

		$txt .= _to_text($el->{_content});
		$txt .= qq(</$el->{_name}>);
	}

	return $txt;
}




1;
