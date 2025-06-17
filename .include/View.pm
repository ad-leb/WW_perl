package View;
use parent WW::View;




sub new 
{
	my ($self, $content) = @_;
	my $page = $self->SUPER::new;
	my ($header, $main, $footer) = (
		$self->header,
		$self->main,
		$self->footer,
	);


	$page->set(
		$self->meta(charset => q(utf-8)),
		$self->title(q(Rebuild)),
		$self->link(rel => q(stylesheet), href => q(/res/css/fresh0.css)),
	);
	$page->push($header, $main, $footer);

	$header->push(
		$self->get_current_nav,
		$self->get_global_nav,
	);
	$main->push(
		$self->p($content),
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
	my @dumb = qw(awebo wako);

	foreach my $pop (@dumb)
	{
		$nav->push(
			$self->a($pop, href => qq(/$pop)),
		);
	}

	return $nav;
}














1;
