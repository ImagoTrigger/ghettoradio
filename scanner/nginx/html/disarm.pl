use strict;
use CGI;

my $q = new CGI;
print $q->header;
print "Security alerting DEACTIVATED, close this page!";
open(TOUCH,">D:\\security.disarmed");
print TOUCH $$;
close TOUCH;
exit;


