use strict;
use Win32::MediaPlayer;
use Time::HiRes qw(usleep);
use POSIX qw(strftime);
use Data::Dumper;
use File::Basename;
    
$| = 1;

open(PID,">R:\\scanner\\kill2.pid");
print PID $$;
close PID;

my $spoketime = 0;
my $sdrdir = "R:/scanner/SDRTrunk/recordings/";
my $winmm = new Win32::MediaPlayer;

open(M3U,"R:\\scanner\\all.m3u");
my @playlist = <M3U>;
close M3U;

my @tunes;
foreach (@playlist) {
	next if $_ =~ /^\#/;
	my $tune = $_;
	chomp $tune;
	push(@tunes,"Z:\\$tune");
}

our %ignore = ();
open(ARMER,"R:/scanner/ignore.txt");
my @rows = <ARMER>;
close ARMER;
foreach my $row (@rows) {
	my ($hex,$alpha) = split(/\t/,$row);
	#$hex = hex($hex);
	chomp $alpha;
	$ignore{$hex} = $alpha;
}

while (1) {
	my %files = get_sorted_files("$sdrdir");
	my $count = scalar keys %files;
	print "$count\n";
	open(LOG,">R:\\scanner\\altacast\\count.log");
	print LOG ($count - 2) ."\n";
	close LOG;	
	goto WAIT if ($count > 2);
	
	my $random_number = int(rand(scalar @tunes));

	print @tunes[$random_number] ."\n";
	open(LOG,">>R:\\scanner\\altacast\\stream.log");
	
	my $dong = @tunes[$random_number];
	my ($dname,$dpath,$dsuffix) = fileparse($dong);
	
	print LOG  $dname . " @ " . strftime("%H%M%S", localtime) ."\n";
	close LOG;
	open(LOG,">R:\\scanner\\altacast\\length.log");
	print LOG "0\n";
	close LOG;
	my $wut = $winmm->load(@tunes[$random_number]);
	$winmm->volL(20);
	$winmm->volR(20);
	$winmm->play;     
	my $max = -1;
	while (1) {
		my $lastmax;
		my $pos = $winmm->pos;
		my %files = get_sorted_files("$sdrdir");
		if (scalar keys %files > 2) {
			$winmm->volL(15);
			$winmm->volR(15);
			Time::HiRes::sleep(0.4); #.1 seconds
			$winmm->volL(10);
			$winmm->volR(10);			
			Time::HiRes::sleep(0.4); #.1 seconds
			$winmm->volL(5);
			$winmm->volR(5);
			Time::HiRes::sleep(0.4); #.1 seconds
			$winmm->volL(1);
			$winmm->volR(1);
			Time::HiRes::sleep(0.2); #.1 seconds
			last;
		}
		if ($max < $pos) {
			$max = $pos;
			$lastmax = 1;
		}
		last if (!$lastmax);
		sleep 1; #.1 seconds
	};
	$winmm->close;
WAIT:	


	 my $DIR2 = $sdrdir;
	 opendir(my $DH, $DIR2) or die "Error opening $DIR2: $!";
	 my %files2 = map { $_ => (stat("$DIR2/$_"))[9] } grep(! /^\.\.?$/, readdir($DH));
	 closedir($DH);
	   foreach my $key (keys %files2) {
		my $to; my $from = "?";
		my $dec; my $meta = $key;
		if ($key =~ /1_2_TRAFFIC__(.*).wav/) {
			$meta = $1;
			if ($meta =~ /TO_(.*?)_/) {
				$dec = $1;
			}
		}
		if ($ignore{$dec} || $key =~ /\.tmp/) {
			delete $files2{$key};
		}	
	   }	 
	 my @sorted_files2 = reverse sort { $files2{$b} <=> $files2{$a} } (keys %files2);
	 my $fff = (stat($DIR2.'/'.$sorted_files2[0]))[9];
		my $len = time - $fff;
	open(LOG,">R:\\scanner\\altacast\\length.log");
	
	print LOG sprintf("%.3f", $len/60) ."\n";
	close LOG;	

	my $speak = 0;
	if ($count > 100 && $count <= 1000) {
		my $tdiff = time - $spoketime;
		$speak = 1 if $tdiff > 300;
		if ($speak || !$spoketime) {
			$spoketime = time;
			system(qq{perl R:\\scanner\\speak.pl "scanner is $count calls behind!"});
		}
		
		#sleep (5*60) if ($count > 500);
		#sleep abs($len) * 1.5;
		sleep 3;
	} elsif ($count > 1000) {
		$speak = 1 if (time - $spoketime > 900);
		if ($speak || !$spoketime) {
			$spoketime = time;
			system(qq{perl R:\\scanner\\speak.pl "scanner is way behind!"}) if $speak;  
			
		}
		#sleep (15*60);
		#sleep abs($len) * 1.5;
		sleep 5;
	}

	sleep 2; #.1 seconds	
}

sub get_sorted_files {
   my $path = shift;
   opendir my($dir), $path or die "can't opendir $path: $!";
   my %hash = map {$_ => (stat($_))[9] || undef} # avoid empty list
           map  { $_ !~ /\.tmp/ ? "$path$_" : () }
           readdir $dir;
   closedir $dir;
   foreach my $key (keys %hash) {
	my $to; my $from = "?";
	my $dec; my $meta = $key;
	if ($key =~ /1_2_TRAFFIC__(.*).wav/) {
		$meta = $1;
		if ($meta =~ /TO_(.*?)_/) {
			$dec = $1;
		}
	}
	if ($ignore{$dec}) {
		print "Ignoring $key (".$ignore{$dec}.")\n";
		delete $hash{$key};
		unlink $key; #deletes the .wav
	}	
   }
   return %hash;
}

__END__
use Speech::Synthesis;
my $ss;

     my $engine = 'SAPI5'; # or 'SAPI4', 'MSAgent', 'MacSpeech' or 'Festival' 
     my @voices = Speech::Synthesis->InstalledVoices(engine => $engine);
 
     foreach my $voice (@voices)
     {
     	if ($voice->{id} =~ /Zira/i) {
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