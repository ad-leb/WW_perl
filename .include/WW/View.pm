package WW::View;
use parent WW::Html;






sub wrap
{
	my ($self, $obj) = @_;					return q() if $obj->{header}{Location};
	my $mime = ($obj->{header}{q(Content-Type)} =~ /^([\w\/]*)/)[0];

	if ( $mime eq q(text/html) ) {
		my $page;

		$page = $self->page($obj->{content});
		$page->set($_) foreach $obj->{meta}->@*;

		$obj->{content} = $page->to_text;
	}

	return $obj;
}


sub page
{ 
	($_[0]->SUPER::page)[0];
}




sub set											{ my $this = shift; my $obj = $this->head; push $obj->{_content}->@*, @_ }

sub push										{ my $this = shift; my $obj = ($this->{_name} eq q(_)) ? $this->body : $this; push $obj->{_content}->@*, @_ }
sub pop											{ my $this = shift; my $obj = ($this->{_name} eq q(_)) ? $this->body : $this; pop $obj->{_content}->@* }
sub unshift										{ my $this = shift; my $obj = ($this->{_name} eq q(_)) ? $this->body : $this; unshift $obj->{_content}->@*, @_ }
sub shift										{ my $this = shift; my $obj = ($this->{_name} eq q(_)) ? $this->body : $this; shift $obj->{_content}->@* }










sub error_404
{
	my ($self) = @_;

	print STDOUT qq(Status: 404 No that action, dude\r\n);
	print STDOUT qq(Content-Type: text/html\r\n\r\n);
	print STDOUT ($self->page(qq(<hr/><h3>Here is no that action, dude :S</h3><hr/>)))->to_text;
	exit;
}
sub error_500
{
	my ($self) = @_;

	print STDOUT qq(Status: 500 Wow, got an error\r\n);
	print STDOUT qq(Content-Type: text/html\r\n\r\n);
	print STDOUT ($self->page(qq(<hr/><h3>Oops, got error! HTTP: 500</h3><hr/>)))->to_text;
	exit;
}








1;
