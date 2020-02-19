use strict;
use File::Copy;
use File::ReadBackwards;
unlink("R:\\scanner\\stash.txt");
unlink("D:\\front.txt");
print "starting\n";
while(1) {
	if (-e "R:\\scanner\\stash.txt") {
		unlink("R:\\scanner\\stash.txt");
		rmdir("R:\\scanner\\stash.txt");
		my $DIR = "R:\\scanner\\SDRTrunk\\recordings";

		opendir(my $DH, $DIR) or die "Error opening $DIR: $!";

		system(qq{perl R:\\scanner\\speak.pl "scanner is about to stash the queue!"});  

		 my %files = map { $_ => (stat("$DIR/$_"))[9] } grep(! /^\.\.?$/, readdir($DH));
		 closedir($DH);
		 my @sorted_files = sort { $files{$b} <=> $files{$a} } (keys %files);
		 my $moved = 0;
		 my $now = time;
		 mkdir("D:\\scanner\\stash\\$now");
		 foreach my $file (@sorted_files) {
			$moved++ if move("$DIR\\$file","D:\\scanner\\stash\\$now\\$file");

		 }

		 open(PID1,"R:\\scanner\\kill1.pid");
		 my $pid1 = <PID1>;
		 close PID1;
		  open(PID2,"R:\\scanner\\kill2.pid");
		  my $pid2 = <PID2>;
		 close PID2; 

		 system("TASKKILL /F /PID $pid1 /T 2>nul");
		 system("TASKKILL /F /PID $pid2 /T 2>nul");


		 print "stashed $moved of ".scalar @sorted_files." calls\n";

		system(qq{perl R:\\scanner\\speak.pl "scanner moved $moved calls!"});  


		system("rmdir /Q /S C:\\ramdisk\\scanner\\SDRTRunk\\recordings");
		
	} 
	if (-e "D:\\front.txt" && !-e "D:\\security.disarmed") {
		open(LOG,">>R:\\scanner\\altacast\\stream.log");
		print LOG "[<a href=rtsp://scanner.bad.mn:8003/play2.sdp>FRONT</a>] <a href=/live2/image/jpeg.cgi>live jpeg</a>\n";
		close LOG;    
		system(qq{perl R:\\scanner\\speak.pl "Security alert, front"});  
	}
	unlink "D:\\front.txt";
	if (-e "R:\\scanner\\altacast\\sensor.log") {
		my $bw = File::ReadBackwards->new( "R:\\scanner\\altacast\\sensor.log" ) or die "can't read 'log_file' $!" ;
		my $log_line = $bw->readline;
		$bw->close;
		my ($time,$temp,$memused) = split(',',$log_line);
		print "$time - $temp - $memused\n";
		if ($temp =~ /(\d+)/) { #150 is fine
			if ($1 > 173) { #hot!
				system(qq{perl R:\\scanner\\speak.pl "Scanner alert, high CPU temperature!"});  
			}
		}
		if ($memused =~ /(\d+)/) { #5000 is fine
			if ($1 > 10000) { #alot!
				system(qq{perl R:\\scanner\\speak.pl "Scanner alert, high memory use!"});  
			}
		}
		
	}
	print "sleeping\n";
	sleep 5;
}






