use View;



my $form = View->form(action => q(/login), method => q(post));

$form->push(
	$form->div(
		[
			$form->label(q(Логин: ), for => q(login)),
			$form->input(type => q(text), name => q(login), id => q(login)),
		]
	),

	$form->div(
		[
			$form->label(q(Пароль: ), for => q(password)),
			$form->input(type => q(password), name => q(password), id => q(password)),
		]
	),

	$form->div(
		[
			$form->input(type => q(submit), value => q(Отправить)),
		]
	),
);

return $form;
