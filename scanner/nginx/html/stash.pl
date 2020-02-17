use strict;
use CGI;

my $q = new CGI;
print $q->header;
print "Stashing now, close this page!\n<br>";
print $ENV{QUERY_STRING};
open(TOUCH,">R:\\scanner\\stash.txt");
print TOUCH $$;
close TOUCH;
exit;


