use strict;
use Net::Nslookup;
use LWP::UserAgent;
use Net::CIDR::Lite;
use Try::Tiny;

open(ALLOW,">dynallow.p2p");

my @addrs = nslookup "0.nettime.pool.ntp.org";
push @addrs, nslookup "1.nettime.pool.ntp.org";
push @addrs,  nslookup "2.nettime.pool.ntp.org";
push @addrs,  nslookup "3.nettime.pool.ntp.org";
foreach my $addr (@addrs) {
	print ALLOW "NTP:$addr-$addr\n";
}
@addrs=();
push @addrs,  nslookup "feed.adsbexchange.com";
foreach my $addr (@addrs) {
	print ALLOW "ADSBX:$addr-$addr\n";
}
@addrs=();
push @addrs,  nslookup "smtp.gmail.com";
foreach my $addr (@addrs) {
	print ALLOW "GMAIL:$addr-$addr\n";
}
@addrs=();
push @addrs,  nslookup "afraid.org";
push @addrs,  nslookup "ns1.afraid.org";
push @addrs,  nslookup "ns2.afraid.org";
push @addrs,  nslookup "ns3.afraid.org";
foreach my $addr (@addrs) {
	print ALLOW "AFRAID:$addr-$addr\n";
}
@addrs=();
push @addrs,  nslookup "techknowpro.com";
foreach my $addr (@addrs) {
	print ALLOW "FREEDNS:$addr-$addr\n";
}
@addrs=();
push @addrs,  nslookup "ip.filezilla-project.org";
foreach my $addr (@addrs) {
	print ALLOW "FILEZILLA:$addr-$addr\n";
}
@addrs=();
push @addrs,  nslookup "webservice.virtualradarserver.co.uk";
push @addrs,  nslookup "sdm.virtualradarserver.co.uk";
push @addrs,  nslookup "www.virtualradarserver.co.uk";
foreach my $addr (@addrs) {
	print ALLOW "VRS:$addr-$addr\n";
}
@addrs=();
push @addrs,  nslookup "bot.whatismyipaddress.com";
push @addrs,  nslookup "emby.media";
foreach my $addr (@addrs) {
	print ALLOW "EMBY:$addr-$addr\n";
}
close ALLOW;




unlink("R:\\scanner\\PeerBlock\\cache.p2b");
system('start /MIN /D "R:\\scanner\\PeerBlock" peerblock');

__END__

NEW PARSE:
<td class='table-column-CIDR_Range'>(.*)</td>


the new URL is https://mxtoolbox.com/SuperTool.aspx?action=asn%3aAS10507&run=toolpage


my $ua = LWP::UserAgent->new;
my $req = HTTP::Request->new(GET => 'http://mxtoolbox.com/api/v1/lookup/ASN/AS10507');
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
} else {
	print "failed to get mxtoolbox.com\n";
}