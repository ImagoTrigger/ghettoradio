use strict;
use Device::Modem;
use Data::Dumper;

$| = 1;

print "Connecting serial port...\n";
my $modem = new Device::Modem(port=>'COM4');
$modem->connect();
print "Connected...\n";
my $skip = 0;
my $inv = 0;
my $rows = 0;
my $rows2 = 0;
sleep 3;
while (1) {
	my %signals = $modem->status;
	
	if ($signals{RING} > 0) {
		print  "On battery backup power! $skip $rows $signals{RING}\n";
		if ($rows == 3) {
			open(LOG,">R:\\scanner\\altacast\\ups.log");
			print LOG '1';
			close LOG;
		}
		if ($skip <= 0 && $rows == 3) {
			system(qq{perl R:\\scanner\\speak.pl "scanner is on backup power!"});
			$inv = 1;
			$skip = 100 if ($skip <= 0);
		}
		$rows = 0 if $rows == 3;
		$rows2 = 0;
		$rows++;
		sleep 0.5;
		
	} else {
		print  "On line power! $inv $rows2 $signals{RING}\n";
		system(qq{perl R:\\scanner\\speak.pl "scanner power restored!"}) if ($inv && $rows2 == 2);
		if ($rows2 == 3) {
			open(LOG,">R:\\scanner\\altacast\\ups.log");
			print LOG '0';
			close LOG;
			$rows2 = 0;
			$inv = 0;
		}		
		$skip = 0;
		$rows = 0;
		$rows2++;
	}
	sleep 3;
	$skip--;
}