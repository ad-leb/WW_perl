package WW::DB;
use DBI;
use Carp;











our $dbh;
our $AUTOLOAD;
our $data = {
	access						=> {
		dbd						=> q(mysql),
		name					=> q(fresh),
		user					=> q(fresh),
		pass					=> q(fresh),
		host					=> q(localhost),
	},
	request						=> {
		get_article_by_id		=> q(SELECT * FROM article WHERE id=$id),
	},
};












sub AUTOLOAD
{
    &__connect if !$dbh;

    my ($self, $param) = @_;
    my $req = ($AUTOLOAD =~ /.*::(.*)$/)[0];
    my $sth;
    my $sql = $data->{request}{$req};       
	
	$sql =~ s/\$(\w+)/$param->{$1}/g;

    $sth = $dbh->prepare($sql);         croak(qq(<<$sql>>: SQL Error! ) . $dbh->errstr) if $sth->err;
    $sth->execute;                      return if $sth->err;    # Croak made undetermined loop with little databoom. From now I will be cariful.

    return $sth->fetchall_hashref(q(id)) if $sql =~ /^SELECT/;
}






sub __connect
{
    $dbh = DBI->connect(qq(DBI:$data->{access}{dbd}:database=$data->{access}{name}), $data->{access}{user}, $data->{access}{pass}) or croak(qq(Can't connect to $data->{access}{name}: $!));
    DBI->trace($data->{access}{tracing}, $data->{access}{tracing_filename}) if $data->{access}{tracing};
}















1;
