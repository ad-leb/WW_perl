package WW::Xml;



our $AUTOLOAD;
our @dtd = qw(
	DOCTYPE
	xml
);






sub AUTOLOAD
{
	my $self = shift;
	my $content = shift if @_ % 2;
	my %param = @_;
	my ($class, $name) = ($AUTOLOAD =~ /(.*)(?:::SUPER)::(.*)$/);
	my $obj;

	$obj->{_single} = 0;
	$obj->{_name} = $name;
	$obj->{_content} = $content;
	$obj->{$_} = $param{$_} foreach (keys %param);

	$obj->{_name} = qq(!$name) if grep /^$name$/i, @dtd;

	ref $self
		? bless $obj, $class
		: bless $obj, $self
	;
}
sub DESTROY										{ undef $_[0] }







sub push										{ my $this = shift; push $this->{_content}->@*, @_ }
sub pop											{ pop $_[0]->{_content}->@* }
sub unshift										{ my $this = shift; unshift $this->{_content}->@*, @_ }
sub shift										{ shift $_[0]->{_content}->@* }









sub to_text
{
	my ($this) = @_;
	my $txt;

	return $this if !ref $this;
	return join q(), map $_->to_text, $this->{_content}->@* if $this->{_name} eq q(_);

	$txt .= qq(<$this->{_name});
	map {
		$txt .= qq( $_);
		$this->{$_} and $txt .= qq(="$this->{$_}")
	} grep /^[a-zA-Z]/, keys $this->%*;
	$txt .= q(>);
	
	unless ( $this->{_single} ) {
		if ( ref $this->{_content} eq q(ARRAY) ) {
			$txt .= join q(), map { $_->to_text } $this->{_content}->@*;
		} elsif ( ref $this->{_content} ) {
			$txt .= $this->{_content}->to_text;
		} else {
			$txt .= $this->{_content};
		}

		$txt .= qq(</$this->{_name}>);
	}

	return $txt;
}


sub get
{
	my $this = shift;
	my $name = shift if @_ % 2;
	my %param = @_;
	my @res;

	push @res, $this if 
		$this->{_name} eq $name
			or
		%param and (keys %param) == (map { $this->{$_} =~ /$param{$_}/ } keys %param)
	;

	push @res, map {
		$_->get($name, %param)
	} $this->{_content}->@*;

	return @res;
}













1;
