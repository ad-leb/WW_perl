package WW::Parse;


my $mark = q(__mark) . time . time . q(__);






sub DESTROY						{ }






sub md_to_html
{
	my ($self, $txt) = @_;
	my @codeblock;

	$_ = $txt;

				
	# Codeblock pull
	@codeblock = $self->md_code_pull;

	# Tag <hN> table
	s/^\s*(?!\\)######\s*(.*)\s*$/<h6>$1<\/h6>/mg;
	s/^\s*(?!\\)#####\s*(.*)\s*$/<h5>$1<\/h5>/mg;
	s/^\s*(?!\\)####\s*(.*)\s*$/<h4>$1<\/h4>/mg;
	s/^\s*(?!\\)###\s*(.*)\s*$/<h3>$1<\/h3>/mg;
	s/^\s*(?!\\)##\s*(.*)\s*$/<h2>$1<\/h2>/mg;
	s/^\s*(?!\\)#\s*(.*)\s*$/<h1>$1<\/h1>/mg;

	# Inline tags
	s/^(?!($mark|<)).+$/<p>$&<\/p>/mg;													# Tag <p> for each article
	s/(\r?\n){2,}/\n\n/sg; s/^\s*$/<br\/>/mg;											# Tag <br/> single for all spaces
	s/\*\*(\S.*\S)\*\*/<b>$1<\/b>/mg;													# Tag <b> for bold
	s/\*(\S.*\S)\*/<i>$1<\/i>/mg;														# Tag <i> for italic
	s/`(\S.*\S)`/<code>$1<\/code>/mg;													# Tag <code> for inline code
	s/(<p>)?_{3}(<\/p>)?/<hr\/>/mg;														# Tag <hr/>

	# Link and image
	s/!\[(.*?)\]\((\S*)\s+"(.*?)"\s?\)/<img src="$2" title="$3" alt="$1" \/>/mg;
	s/!\[(.*?)\]\((\S*)\)/<img src="$2" alt="$1" \/>/mg;
	s/\[(.*?)\]\((\S*)\s+"(.*?)"\s?\)/<a href="$2" title="$3">$1<\/a>/mg;
	s/\[(.*?)\]\((\S*)\)/<a href="$2">$1<\/a>/mg;

	# Codeblock push
	$txt = $self->md_code_push(@codeblock);


	return $_;
}
sub md_code_pull
{
	my @codeblock;

	while ( /\n``` ?(\w*)(.*?)\n```\r?\n/s )
	{
		my $block;
			$block->{extension} = $1 if $2;
			$block->{content} = $+;		

		$block->{content} =~ s/&/&amp;/mg;	
		$block->{content} =~ s/</&lt;/mg;	
		$block->{content} =~ s/>/&gt;/mg;

		s/\n``` ?(\w*)(.*?)\n```\r?\n/\n$mark\n/s;

		push @codeblock, $block;
	}

	return @codeblock;
}
sub md_code_push
{
	my ($dum, @codeblock) = @_;

	while ( /$mark/ )
	{
		my $block = shift @codeblock;
		s/$mark/<pre><code class='$block->{extension}'>$block->{content}\n<\/code><\/pre>/m;
	}
}





sub http_urlencoded
{
    map { /(\w+)=([\w\+\%\.]*)/sg } @_;
}
sub http_data
{
    my $bound = q(--) . ($ENV{CONTENT_TYPE} =~ /boundary=(.*)/)[0];
    my $end = $bound . q(--);
    my %data;

    {
        my $name = 1;

        foreach ( @_ )
        {
            /^$/ and next;
            $name = (/name="(.*)"/)[0] and next if !$name;

            /$end/
                and last
            or /$bound/
                and undef $name
            or $name
                and $data{$name} .= $_
            ;
        }
        map { $_ =~ s/(^\s*|\s*$)//sg } values %data;
    }

    return \%data;
}
sub http_plain
{
    my %data;

    {
        my $name = 1;
        foreach (@_)
        {
            if ( /^(\w+)=(.*)/ ) {
                $name = $1;
                $data{$name} = $2;
            } else {
                $data{$name} .= $_;
            }
        }
    }

    return \%data;
}





















1;
