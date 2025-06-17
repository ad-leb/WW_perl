package WW::View;
use parent WW::Html;






sub new
{ 
	($_[0]->page)[0];
}




sub set											{ my $this = shift; my $obj = $this->head; push $obj->{_content}->@*, @_ }

sub push										{ my $this = shift; my $obj = ($this->{_name} eq q(_)) ? $this->body : $this; push $obj->{_content}->@*, @_ }
sub pop											{ my $this = shift; my $obj = ($this->{_name} eq q(_)) ? $this->body : $this; pop $obj->{_content}->@* }
sub unshift										{ my $this = shift; my $obj = ($this->{_name} eq q(_)) ? $this->body : $this; unshift $obj->{_content}->@*, @_ }
sub shift										{ my $this = shift; my $obj = ($this->{_name} eq q(_)) ? $this->body : $this; shift $obj->{_content}->@* }













1;
