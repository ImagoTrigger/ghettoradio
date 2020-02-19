use strict;
use LWP::UserAgent;
use Net::CIDR::Lite;
use Data::Dumper;

my $ua = LWP::UserAgent->new;
my $req = HTTP::Request->new(GET => 'https://mxtoolbox.com/api/v1/Lookup?command=asn&argument=as10507&resultIndex=2&disableRhsbl=true&format=2');
$req->header('content-type' => 'application/json');
$req->header('TempAuthorization' => 'd9d33979-9580-4f2a-b9ee-a9cef7e58fd5');
my $resp = $ua->request($req);
#print Dumper($resp);
if ($resp->is_success) {
    my $message = $resp->decoded_content;
    #print $message;
    my @lines = split("</tr>",$message);
    my @cidrs;
    foreach my $line (@lines) {
    	if ($line =~ /\<td class='table-column-CIDR_Range'\>(.*?)\<\/td\>/) {
    		push(@cidrs,$1);
    	}
    }
    my $cidr = Net::CIDR::Lite->new();
    foreach (@cidrs) {	
    	$cidr->add($_);
    }
    my @cidr_list = $cidr->list_range;
    open(ALLOW,">asnallow.p2p");
	foreach my $addr (@cidr_list) {
		print  "AS10507:$addr\n";
	}    
    close ALLOW;
}