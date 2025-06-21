package Root;






sub get
{
	my ($self, $path) = @_;

	return {
		status					=> 200,
		header					=> {
			q(Content-Type)		=> q(text/html; charset=utf-8),
		},
		meta					=> [
			View->title(q(Главная страница)),
			View->link(rel => q(stylesheet), href => q(test_link)),
		],
		content					=> q(Hello! It's a root page),
	};
}









1;
