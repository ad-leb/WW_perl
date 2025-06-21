package WW::View;
use parent WW::Html;
use WW;
use JSON;






sub wrap
{
	my ($self, $obj) = @_;
	my $mime = ($obj->{header}{q(Content-Type)} =~ /^([\w\/]*)/)[0];

	return $self->wrap_html($obj) if $mime eq q(text/html);
	return $self->wrap_json($obj) if $mime eq q(application/json);

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







sub wrap_html
{
	my ($self, $obj) = @_;
	my $page;

	$page = $self->page($obj->{content});
	$page->set($_) foreach $obj->{meta}->@*;

	$obj->{content} = $page->to_text;

	return $obj;
}
sub wrap_json
{
	my ($self, $obj) = @_;

	$obj->{content} = to_json($obj->{content}, {allow_blessed => 1, pretty => 1, utf8 => 1});

	return $obj;
}














1;
