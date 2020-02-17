use strict;
use LWP::UserAgent;
use Net::CIDR::Lite;

my $ua = LWP::UserAgent->new;
my $req = HTTP::Request->new(GET => 'https://mxtoolbox.com/api/v1/lookup/ASN/AS10507');
$req->header('content-type' => 'application/json');
$req->header('Authorization' => '3fec7256-a268-4ae9-829a-22a960dace10');
my $resp = $ua->request($req);
if ($resp->is_success) {
    my $message = $resp->decoded_content;
    my @lines = split(/\n/,$message);
    my @cidrs;
    foreach my $line (@lines) {
    	if ($line =~ /\"CIDR Range\"\: \"(.*?)\"/) {
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
		print ALLOW "AS10507:$addr\n";
	}    
    close ALLOW;
}