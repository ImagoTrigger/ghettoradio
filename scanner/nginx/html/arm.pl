use strict;
use CGI;

my $q = new CGI;
print $q->header;
print "Security alerting ACTIVATED, close this page!";
unlink("D:\\security.disarmed");

exit;


