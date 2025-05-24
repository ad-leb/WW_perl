package View::First;
use parent View;




sub set_head
{
	my ($self, $head) = @_;

	$head->push(0, charset => q(utf-8));
}


sub form
{
	my ($this, $data) = @_;
	my $form = $this->SUPER::form;

	foreach my $el ($data->@*)
	{
		$form->push($this->label($el->{label})) if $el->{label};
		$form->push($this->input(q(), type=>$el->{type}, name=>$el->{name}, value=>$el->{value}));
	}

	return $form;
}












1;
