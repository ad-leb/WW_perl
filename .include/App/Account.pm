package Account;
use WW;
use Digest::SHA qw(sha256_hex);




sub get
{
	if ( !$WW::env{uri_path} ) {
		return {
			status				=> 301,
			header				=> {
				q(Location)		=> q(/account/auth),
			},
		};
	}

	return &{qq(get_$WW::env{uri_path})};
}


sub post
{
	return &{qq(post_$WW::env{uri_path})};
}














sub hello
{
	return {
		status					=> 200,
		header					=> {
			q(Content-Type)		=> q(text/html; charset=utf-8),
		},
		meta					=> [
			$WW::view->title(q(Привет!)),
		],
		content					=> [
			$WW::view->hr,
			$WW::view->p(qq(Привет, $WW::env{user}!)),
			$WW::view->hr,
		],
	};
}
sub get_auth
{
	my $form = $WW::view->form(action => q(/account/auth), method => q(post), enctype => q(text/plain));
	
	$form->push(
		$form->div(
			[
				$form->label(q(Логин: ), for => q(name)),
				$form->input(type => q(text), name => q(name), id => q(name)),
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
				$form->input(type => q(submit), value => q(Войти)),
			]
		),
	);
	
	return {
		status					=> 200,
		header					=> {
			q(Content-Type)		=> q(text/html; charset=utf-8),
		},
		meta					=> [
			$WW::view->title(q(Аутентификация)),
		],
		content					=> [
			$WW::view->h2(q(Аутентификация)),
			$WW::view->br, 
			$form,
		],
	};
}

sub get_new
{
	my $form = $WW::view->form(action => q(/account/new), method => q(post), enctype => q(text/plain));

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
				$form->label(q(Ваше имя (как вас называть): ), for => q(pretty)),
				$form->input(type => q(text), name => q(pretty), id => q(pretty)),
			]
		),
		$form->div(
			[
				$form->input(type => q(submit), value => q(Зарегистрироваться)),
			]
		),
	);

	return {
		status					=> 200,
		header					=> {
			q(Content-Type)		=> q(text/html; charset=utf-8),
		},
		meta					=> [
			$WW::view->title(q(Регистрация)),
		],
		content					=> [
			$WW::view->h2(q(Регистрация)),
			$WW::view->br, 
			$form,
		],
	};
}





sub post_auth
{
	my $obj = WW::DB->get_user_by_name({name => $WW::env{POST}{name}});
	my ($id) = keys $obj->%*;
	my ($salt, $target) = ($obj->{$id}{salt}, $obj->{$id}{digest});
	my $attempt = &_get_digest($salt . $WW::env{POST}{password});
	my $data = {
			name				=> $WW::env{POST}{name},
			password			=> $WW::env{POST}{password},
			salt				=> $salt,
			target				=> $target,
			got					=> $attempt,
	};

	return {
		status					=> 202,
		header					=> {
			q(Content-Type)		=> q(application/json; charset=utf-8),
		},
		content					=> $data,
	};
}

sub post_new
{
	my $data = {
		salt					=> &_new_salt,
		name					=> $WW::env{POST}{name},
		pretty					=> $WW::env{POST}{pretty},
	};
	$data->{digest} = &_get_digest($data->{salt}, $WW::env{POST}{password});

	WW::DB->new_user($data);

	return {
		status					=> 301,
		header					=> {
			q(Location)			=> q(/account/auth),
		},
	};
}







sub _new_salt
{
	my $salt;
	
	open my $rand, q(/dev/random);
	sysread($rand, $salt, 32);
	close $rand;
	
	return join q(), unpack(q(h*), $salt);
}
sub _get_digest
{
	my ($salt, $password) = @_;
	return sha256_hex($salt . $password);
}






1;
