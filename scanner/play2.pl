use strict;
use Win32::MediaPlayer;
use Win32::GUI;
use Time::HiRes;
use threads;
use Thread::Queue;
use POSIX qw(strftime);

open(PID,">R:\\scanner\\kill1.pid");
print PID $$;
close PID;


my ( $q, $thr );
our (%armer, %radios, %ignore, @tunes);
sub main {

  my $win = Win32::GUI::Window->new(
    -name  => 'MainWindow',
    -title => 'Scanner Recordings Playback',
	  -pos   => [100,100],
	  -size  => [512,1],
  );

	print "loading lists\n";

	open(ARMER,"armer2.txt");
	my @rows = <ARMER>;
	close ARMER;
	foreach my $row (@rows) {
		my ($hex,$alpha) = split(/\t/,$row);
		#$hex = sprintf("%04X",$hex);
		$armer{$hex} = $alpha;
	}
  	print scalar @rows ." talkgroup names found\n";
	open(ARMER,"radios.txt");
	my @rows = <ARMER>;
	close ARMER;
	foreach my $row (@rows) {
		if ($row =~ /(\d+?) (.*)/) {
			my $hex = $1; #sprintf("%06X",$1);
			$radios{$hex} = $2;
		}
	}	
  	print scalar @rows ." radio names found\n";
	open(ARMER,"ignore.txt");
	my @rows = <ARMER>;
	close ARMER;
	foreach my $row (@rows) {
		my ($hex,$alpha) = split(/\t/,$row);
		#$hex = hex($hex);
		chomp $alpha;
		$ignore{$hex} = $alpha;
	}	
	print scalar @rows ." ignored TGIDs  found\n";
	
	open(M3U,"all.m3u");
	my @playlist = <M3U>;
	close M3U;

	foreach (@playlist) {
		next if $_ =~ /^\#/;
		my $tune = $_;
		chomp $tune;
		push(@tunes,"E:\\$tune");
	}
	print scalar @tunes ." tunes found\n";

	print "starting main worker thread\n";

  $q   = Thread::Queue->new();
  $thr = threads->new(\&worker, $win, "SDRTrunk/recordings/");

  $win->Show();
  $win->Text("Starting dirmon...");
  $q->enqueue("dirmon");
  Win32::GUI::Dialog();

}

sub worker {
  my ($win,$sdrdir) = @_;
  
  while (my $request = $q->dequeue) { 
      print "$request $win\n";
	$win->Text("Idle...");
	if ($request eq 'dirmon') {
		while(1) {	
			my @files2 = getfiles($sdrdir);

			if (scalar @files2 > 0) {
				my $play = threads->new(\&thrsub, \@files2, $win);
				$play->join();
			} else {	
			#	my $play2 = threads->new(\&thrsub2, \@files2, $win);
			#	$play2->detach();
			#	while(scalar getfiles($sdrdir) == 0 && $play2->is_running()) {
			#		Time::HiRes::sleep(0.25);
			#		print "playing music...\n";
			#	}
			#	$play2->kill('KILL');
				$win->Text("Idle...");
			}

			#print "\n\n";
			Time::HiRes::sleep(0.75);
		}
   	 }  
  return 0;
  }
}
sub getfiles {
	my $sdrdir = shift;
	my %files = get_sorted_files($sdrdir);
	my @files2 = sort{$files{$a} <=> $files{$b}} keys %files;

	restart:
	my $index = 0;
	foreach my $key (@files2) {
		if ($key =~ /$sdrdir\./i || $key =~ /$sdrdir\.\./i) {
			splice @files2,$index,1;
			goto restart;
		}
		if ($key =~ /\.tmp/) {
			splice @files2,$index,1;
			goto restart;
		}
		my $meta = $key;
		my $to; my $from = "?";
		my $dec;
		if ($key =~ /1_2_TRAFFIC__(.*).wav/) {
			$meta = $1;
			if ($meta =~ /TO_(.*?)[\.|_]/) {
				$dec = $1;
				$to = $armer{$1};
				chomp $to;
				$to = $1 if (!$to);
			}
			if ($meta =~ /FROM_(.*)/) {
				$from = $radios{$1};
				chomp $from;
				$from = $1 if (!$from);
			}
		}
		if ($ignore{$dec}) {
			print "Ignoring $key (".$ignore{$dec}.")\n";
			unlink $key; #deletes the .wav
			splice @files2,$index,1;
			goto restart;
		}
		#print "working on $key\n";
		$index++;
	}
	return @files2;
}


sub thrsub {
	my ($files, $win) = @_;
	my @files = @{$files};
	my $count = (scalar @files);
	print "in playback thread with $count recordings\n";
	while (@files) {
		if ($count > 30) {
			my $left = shift @files;
			my $right = shift @files;
			#print "$left and $right\n";
			my $playL = threads->new(\&doplay, $left, 100,0,$win, 1);
			$playL->detach();
			my $playR = threads->new(\&doplay, $right, 0,100,$win, 1);
			$playR->detach();
			while(@files) {
				if (!$playL->is_running()) {
					$left = shift @files;
					$playL = threads->new(\&doplay, $left, 100,0,$win, 1);
					$playL->detach();
				}
				if (!$playR->is_running()) {
					$right = shift @files;
					$playR = threads->new(\&doplay, $right, 0,100,$win, 1);
					$playR->detach();
				}
				Time::HiRes::sleep(0.25);
			}
		} else {
			#doplay(@tunes[$random_number],20,20,$win, 0);  #thread here! TODO
			
			my $stereo = shift @files;
			#print "stereo $stereo\n";
			doplay($stereo,100,100,$win, 1);	
		}
	Time::HiRes::sleep(0.25);
	}
};

sub doplay {
	my ($key,$volL,$volR,$win, $delete) =@_;
	my $skey = -s $key;
	my $meta = $key;
	my $to; my $from = "?";
	my $dec;
	if ($key =~ /1_2_TRAFFIC__(.*)wav/) {
		$meta = $1;
		if ($meta =~ /TO_(.*?)[\.|_]/) {
			$dec = $1;
			$to = $armer{$1};
			chomp $to;
			$to = $1 if (!$to);
		}
		if ($meta =~ /FROM_(.*)[\.|_]/) {
			$from = $radios{$1};
			chomp $from;
			$from = $1 if (!$from);
		}
	}
	if ($ignore{$dec}) {
		print "Ignoring $key (".$ignore{$dec}.")\n";
		unlink $key; #deletes the .wav
		return 0;
	}
	return 0 if (!-e $key);
	print "Playing $key ($skey bytes)\n";	 		
	$win->Text($"TO:$to FROM:$from");
	my $skey = -s $key;
	my $logside = "BOTH";
	if ($volL == 0 && $volR == 100) { $logside = "RIGHT"}
	if ($volL == 100 && $volR == 0) { $logside = "LEFT"}
	open(LOG,">>R:\\scanner\\altacast\\stream.log");
	print LOG "[$logside] TO:$to FROM:$from ($skey bytes)@ ".strftime("%H%M%S", localtime)."\n";

	my $winmm = new Win32::MediaPlayer;
	my $wut = $winmm->load($key);
	$winmm->volL($volL);
	$winmm->volR($volR);
	$winmm->play;     
	#wait for the file to play
	my $max = -1;
	while (1) {
		my $lastmax;
		my $pos = $winmm->pos;
		if ($max < $pos) {
			$max = $pos;
			$lastmax = 1;
		}
		last if (!$lastmax);
		Time::HiRes::sleep(0.3);
		#print "in do play...\n";
	};	
	$winmm->close;	
	unlink $key if ($delete);
}

sub MainWindow_Terminate {
  $q->enqueue(undef);  # This is necessary to clean up the worker thread
  $thr->join;
  return(-1);
}

sub get_sorted_files {
   my $path = shift;
   opendir my($dir), $path or die "can't opendir $path: $!";
   my %hash = map {$_ => (stat($_))[9] || undef} # avoid empty list
           map  { "$path$_" }
           readdir $dir;
   closedir $dir;
   return %hash;
}

# Start up...
eval { main() };
Win32::GUI::MessageBox(0, "Error: $@", "DOH") if $@;

__END__

#garbage silence replacement
sub thrsub2 {
	my ($files, $win) = @_;
	my @files = @{$files};
	my $count = (scalar @files);
	print "in music thread with $count recordings\n";
	my $random_number = int(rand(scalar @tunes));
	#print @tunes[$random_number] ."\n";
	doplay(@tunes[$random_number],20,20,$win, 0);
	
	
}