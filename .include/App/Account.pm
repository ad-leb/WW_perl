package Account;
use WW;
use Digest::SHA qw(sha256_hex);
use JSON;




sub get
{
	if ( $WW::env{session} and &session_is_ok ) {
		return &hello;
	} else {
		return &login;
	}
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
	});

	return {
		status					=> 202,
		header					=> {
			q(Content-Type)		=> q(application/json; charset=utf-8),
		},
		content					=> $data,
	};
}














sub hello
{
	return {
		status					=> 200,
		header					=> {
			q(Content-Type)		=> q(text/html; charset=utf-8),
		},
		meta					=> [
			WW::View->title(q(Аутентификация)),
		],
		content					=> [
			WW::View->h2(q(Аутентификация)), 
			WW::View->br, 
			$form,
		],
	};
}
sub login
{
	my $form = WW::View->form(action => q(/account), method => q(post));
	
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
		status					=> 200,
		header					=> {
			q(Content-Type)		=> q(text/html; charset=utf-8),
		},
		meta					=> [
			WW::View->title(q(Аутентификация)),
		],
		content					=> [
			WW::View->h2(q(Аутентификация)),
			WW::View->br, 
			$form,
		],
	};
}












1;
