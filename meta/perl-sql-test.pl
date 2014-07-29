#!/usr/bin/perl
use DBI;
my $dsn = "DBI:mysql:database=twcon:host=localhost";
my $user = "twcon";
my $pass = "ycL7JYNCcTvnu3qL";

my $dbh = DBI->connect($dsn, $user, $pass) or die "Can't connect to database $DBI::errstr\n";

my $sth = $dbh->prepare("SELECT * FROM contest_entry");
$sth->execute();

print "\tQuery results:\n================================================\n";

while ( my @row = $sth->fetchrow_array( ) )  {
         print "@row\n";
}
warn "Problem in retrieving results", $sth->errstr( ), "\n"
        if $sth->err( );

exit;
