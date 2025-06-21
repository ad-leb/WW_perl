package View;
use parent WW::View;





sub me 							{ bless {}, $_[0] }

sub page
{
	my ($self, $content) = @_;
	print STDERR qq(MARK 0: $content);
	my $page = $self->SUPER::page;
	my ($header, $main, $footer) = (
		$self->header,
		$self->main($content),
		$self->footer,
	);


	$page->set(
		$self->meta(charset => q(utf-8)),
		$self->link(rel => q(stylesheet), href => q(/res/css/fresh0.css)),
	);
	$page->push($header, $main, $footer);

	$header->push(
		$self->get_current_nav,
		$self->get_global_nav,
	);
	$footer->push(
		$self->p(q(All right!)),
	);

	return $page;
}
sub get_current_nav
{
	my $self = shift;
	my $nav = $self->nav(class => q(current));
	my $prev;

	$nav->push($self->a(q(/), href => q(/)));
	foreach my $part (split q(/), $ENV{REQUEST_URI})
	{
		$part =~ s/\?.*//g;
		$nav->push(
			$self->a($part, href => qq($ENV{REQUEST_SCHEME}://$ENV{HTTP_HOST}$prev/$part)),
		) if $part;
		$prev .= qq(/$part) if $part;
	}

	return $nav;
}
sub get_global_nav
{
	my $self = shift;
	my $nav = $self->nav(class => q(global));
	my @dumb = qw(account wako);

	foreach my $pop (@dumb)
	{
		$nav->push(
			$self->a($pop, href => qq(/$pop)),
		);
	}

	return $nav;
}











1;
