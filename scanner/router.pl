use strict;
use WWW::Mechanize;
use Time::HiRes qw(usleep);
RESTART:
close(LOG);
my $mech = WWW::Mechanize->new();
$mech->get( "http://192.168.50.1/Main_Login.asp" );

open(PASS,"R:\\scanner\\pass.txt");
my $pass = <PASS>;
close PASS;

 $mech->submit_form(
        form_name => 'form',
        fields      => {
            login_username    => 'admin',
            login_passwd    => $pass,
            login_authorization => 'YWRtaW46Y3RyMTIz',
        }
    );
    $|=1;
    my $prevrx; my $prevtx;
    my $bpsrx; my $bpstx;
    	my $rx; my $tx;
    	my $count = 0;
    	open(LOG,">R:\\scanner\\altacast\\router.log");
    	LOG->autoflush(1);
    while(1) {
	my $content = $mech->post("http://192.168.50.1/update.cgi",['output'=>'netdev','_http_id'=>'TIDe855a6487043d70a'])->decoded_content;    
	my @shit = split("\n",$content);
	goto RESTART if ($content !~ /netdev/);
	if ($shit[3] =~ /rx\:(.*)\,/) {
		$prevrx = $rx;
		$rx =hex($1);
	}
	if ($shit[3] =~ /tx\:(.*)\}/) {
		$prevtx = $tx;
		$tx =hex($1);
	}
		$bpsrx = (($rx - $prevrx) / 1024) / 2;
		$bpstx = (($tx - $prevtx) / 1024) / 2;
		my $rxmb = ($rx / 1024) / 1024;
		my $txmb = ($tx / 1024) / 1024;
		print "RX MB: $rxmb\tTX MB: $txmb\tRX KB/s: $bpsrx\tTX KB/s: $bpstx\n" if ($count > 1);
		print LOG "$bpsrx,$bpstx\n" if ($count > 1 && $bpsrx >= 0 && $bpstx >= 0);
		sleep 2;
		$count++;
	}
	close(LOG);