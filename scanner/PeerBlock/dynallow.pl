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
push @addrs,  nslookup "mxtoolbox.com";
foreach my $addr (@addrs) {
	print ALLOW "MXTOOLBOX:$addr-$addr\n";
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

try {
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
			print ALLOW "AS10507:$addr\n";
			print "AS10507:$addr\n";
		}    
		close ALLOW;
	} else {
		print "failed to do mxtoolbox.com $_\n"
	}
} catch {
	print "failed to try mxtoolbox.com $_\n"
};
unlink("R:\\scanner\\PeerBlock\\cache.p2b");
system('start /MIN /D "R:\\scanner\\PeerBlock" peerblock');

__END__