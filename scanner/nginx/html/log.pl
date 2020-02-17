 use strict;
use CGI;

my $q = new CGI;
my $qs = $q->env_query_string();
#my %v = $q->Vars;
 my $DIR = "R:\\scanner\\SDRTrunk\\event_logs";
 opendir(my $DH, $DIR) or die "Error opening $DIR: $!";
 my %files = map { $_ => (stat("$DIR/$_"))[9] } grep(! /^\.\.?$/, readdir($DH));
 closedir($DH);
 my @sorted_files = sort { $files{$b} <=> $files{$a} } (keys %files);
 my $red;
if ($qs =~ /(.*)&/) {
	$qs = $1;
}
 foreach my $file (@sorted_files) {
 	if ($file =~ /$qs/i) {
 		$red = $file;
 		last;
 	}
 }
print "Location: /log2/$red\n\n";
