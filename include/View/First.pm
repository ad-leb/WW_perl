package View::First;
use parent View;





sub new
{
	my $self = shift;
	my $this = $self->SUPER::new;

	$this->set(
		$this->meta(charset=>q(utf-8)),
		$this->link(rel=>q(stylesheet), href=>q(/res/css/form0.css))
	);

	return $this;
}


sub header
{
	my ($this, $prm) = @_;
	my $obj;

	$obj = $this->SUPER::header();
	$obj->push(
		$this->a(q(pops), href=>q(/pops)),
		$this->a(q(wawa), href=>q(/wawa)),
		$this->a(q(avebo), href=>q(/avebo))
	);

	return $obj;
}

sub main
{
	my ($this, $prm) = @_;
	my $obj;

	$obj = $this->SUPER::main();

	return $obj;
}

sub footer
{
	my ($this, $prm) = @_;
	my $obj;

	$obj = $this->SUPER::footer();
	$obj->push(
		$this->p(q(All right))
	);

	return $obj;
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
