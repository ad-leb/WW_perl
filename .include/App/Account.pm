package Account;
use WW::View;
use WW::DB;
use Digest::SHA qw(sha256_hex);
use JSON;




sub get
{
	my $form = View->form(action => q(/account), method => q(post));
	
	$form->push(
		$form->div(
			[
				$form->label(q(Логин: ), for => q(login)),
				$form->input(type => q(text), name => q(name), id => q(login)),
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
	
	return {
		header					=> {
			q(Status)			=> q[200 Ok :)],
			q(Content-Type)		=> q(text/html; charset=utf-8),
		},
		meta					=> [
			View->title(q(Аутентификация)),
			View->link(rel => q(stylesheet), href => q(test_link)),
		],
		content					=> [
			View->h2(q(Аутентификация)), 
			View->br, 
			$form
		],
	};
}


sub post
{
	my ($salt, $target) = WW::DB->get_digest_by_name({name => $WW::env{POST}{name}});
	my $attempt = sha256_hex($salt . $WW::env{POST}{password});
	my $data = to_json({
			name				=> $WW::env{POST}{name},
			password			=> $WW::env{POST}{password},
			salt				=> $salt,
			target				=> $target,
			got					=> $attempt,
	}, {pretty => 1});

	return {
		header					=> {
			q(Status)			=> q(202 Look data in plain: no need in View yet),
			q(Content-Type)		=> q(application/json; charset=utf-8),
		},
		content					=> $data,
	};
}












1;
