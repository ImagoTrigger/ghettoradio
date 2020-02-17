use strict;
use CGI;
use File::ReadBackwards;

my $q = new CGI;
my $v = $q->env_query_string() || '-1';
print $q->header;

my $bw = File::ReadBackwards->new( "R:\\scanner\\altacast\\sensor.log" ) or die "can't read 'log_file' $!" ;
 

my $c = 0;
while( defined( my $log_line = $bw->readline ) ) {
        print $log_line . "<br/>\n";
	$c++;
	last if $c == $v;
}