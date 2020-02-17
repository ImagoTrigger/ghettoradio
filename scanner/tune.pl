use strict;
use File::ReadBackwards;
use Speech::Synthesis;

my $ss;

     my $engine = 'SAPI5'; # or 'SAPI4', 'MSAgent', 'MacSpeech' or 'Festival' 
     my @voices = Speech::Synthesis->InstalledVoices(engine => $engine);
 
     foreach my $voice (@voices)
     {
     	if ($voice->{id} =~ /Zira|Anna/i) {
         my %params = (  engine   => $engine,
                         avatar   => undef,
                         language => $voice->{language},
                         voice    => $voice->{id},
                         async    => 0
                         );
         $ss = Speech::Synthesis->new( %params );
         last;
         }
    }
    
my $bw;
my $time;
my $rate;
my $line;
my $nac;
my $lasttime = 0;
my $weak;
while (1) {
	my $got2 = 0;
	$bw = File::ReadBackwards->new("R:\\scanner\\SDRTrunk\\logs\\sdrtrunk_app.log") or die "can't read file";
	while( defined( $line = $bw->readline ) ) {
		if ($line =~ /(...) - TSBK\/s: (\d+) \@ (\d+)/) {
			$nac = $1;
			$rate = $2;
			$time = $3;
		}
		if ($time) {
			print "$nac: $rate - $time\n";
			open(TSBK,">>R:\\scanner\\altacast\\$nac.txt");
			print TSBK "$rate\n";
			close TSBK;
			$lasttime = $time if ($time > $lasttime);
			last if ($got2 == 1);
			$got2++;
		}
	}
	$bw->close;
	
	if ($rate < 3) {
		print "no signal\n";
		  $ss->speak("no signal") if ($weak > 2);
		  $weak++;
		  sleep 5;
	} elsif ($rate < 13) {
		print "weak signal\n";
		 #$ss->speak("weak signal!") if ($weak > 2);
		 #$weak++;
		 
	} else {
		$weak = 0;
	}
	if ($lasttime != 0 && $lasttime < (time - 60)) {
		print "app failure\n";
		 $ss->speak("app failure!");
	}
	sleep 3;
}
close TSBK;