use strict;
use Try::Tiny;
use Net::FTP;
my $dir = "D:\\photos3";
my $setalarm = 0;

open(PASS,"R:\\scanner\\pass.txt");
our $pass = <PASS>;
close PASS;

my $findfile = sub {
	 opendir(my $DH, $dir) or die "Error opening $dir: $!";
	 my %files = map { $_ => (stat("$dir\\$_"))[9] } grep(! /^\.\.?$/, readdir($DH));
	 closedir($DH);
	 my @sorted_files = sort { $files{$b} <=> $files{$a} } (keys %files);
	 foreach (@sorted_files) {
	 	if ($_ =~ /\.jpg/i) {
	 		return "$_";
	 	}
	 }
 };


my $alarm = sub {
      		if (!-e "D:\\security.disarmed") {
				my $file = &$findfile();
				print "deal with $file\n";
				open(LOG,">>R:\\scanner\\altacast\\stream.log");
				print LOG "[<a href=/cam3.html>BACK</a>] <a href=/photo3/$file>$file</a>\n";
				close LOG;        		
				system(qq{perl R:\\scanner\\speak.pl "security alert, back"});  
					#send email...
					my $cmd = qq{R:\\scanner\\sendEmail.exe -f imago\@mail.local -t imago\@mail.local  -s localhost:25 -xu imago\@mail.local -xp $pass -u "Back Alert" -m "http://scanner.bad.mn:8002/photo3/$file" -a "$dir\\${file}"};
					my $ret = `$cmd`;        		
			}

				print "Cam 3 activity!\n"; 
};

while (1) {

START:
sleep(5);
	my $ftp = Net::FTP->new("192.168.50.179:2121", Debug => 0);
	my @files = ();
	try {
		$ftp->login("ftp",'ftp');
	} catch {
		sleep(1);
		print "retry login...\n";
		next;
	};
	try {
		$ftp->cwd('/photo');
	} catch {
		sleep(1);
		print "retry cwd...\n";
		next;		
	};
	try {
		@files=$ftp->ls("/");
	} catch {
		sleep(1);
		print "retry ls...\n";
		next;		
	};
	try {
		$ftp->binary();
	} catch {
		sleep(1);
		print "retry binary...\n";
		next;
	};
	foreach my $file (@files) {   
		next if ($file eq '.nomedia');
		print "Downloading file $file\n";
		try {
			if(!$ftp->get("$file","D:\\photos3\\".$file)) {
			 	print "Error getting file: $!\n";
$ftp->quit;
				goto START;	
			} else {
				sleep(3);
				my $rsize = $ftp->size("$file");
				my $lsize = -s "D:\\photos3\\".$file;
				if ($rsize == $lsize) {
					$setalarm = 1;
					print "file: $rsize = $lsize\n";
					$ftp->delete($file);
				} else {
					print "size mismatch, skipping delete for now...\n";
				}
			}
		} catch {
			sleep(1);
			print "retry get/delete...\n";
$ftp->quit;
			goto START;	    
		};
	}
	try {
		$ftp->quit;
	} catch {
		sleep(1);
		print "retry quit...\n";
		next;	
	};

	&$alarm() if $setalarm;

	my $ftp = Net::FTP->new("192.168.50.179:2121", Debug => 0);
	my @files = ();
	try {
		$ftp->login("ftp",'ftp');
	} catch {
		sleep(1);
		print "retry login...\n";
		next;
	};
	try {
		$ftp->cwd('/modet');
	} catch {
		sleep(1);
		print "retry cwd...\n";
		next;		
	};
	try {
		@files=$ftp->ls("/");
	} catch {
		sleep(1);
		print "retry ls...\n";
		next;		
	};
	try {
		$ftp->binary();
	} catch {
		sleep(1);
		print "retry binary...\n";
		next;
	};
	foreach my $file (@files) {   
		next if ($file eq '.nomedia');
		print "Downloading file $file\n";
		try {
			if(!$ftp->get("$file","D:\\cams3\\".$file)) {
			 	print "Error getting file: $!\n";
$ftp->quit;
				goto START;	
			} else {
				sleep(3);
				my $rsize = $ftp->size("$file");
				my $lsize = -s "D:\\cams3\\".$file;
				if ($rsize == $lsize) {
					print "file: $rsize = $lsize\n";
					$ftp->delete($file);
				} else {
					print "size mismatch, skipping delete for now...\n";
					sleep(5);
				}
			}
		} catch {
			sleep(1);
			print "retry get/delete...\n";
$ftp->quit;
			goto START;	    
		};
	}
	try {
		$ftp->quit;
	} catch {
		sleep(1);
		print "retry quit...\n";
		next;	
	};
print "waiting on cam 3 192.168.50.179\n";
	$setalarm = 0;
	sleep(5);
	}
        		