use strict;
use Speech::Synthesis;
use Win32API::File 0.08 qw( :ALL );
use Net::Ping;
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
    
print "waiting for ramdrive to come online...\n";
while (1) {
		sleep 1;
		print "...";
		if (-e  "R:/scanner/SDRTrunk/playlist/default.xml") {goto start};
}
start:
print "\nhere we go..\n";
system("start /ABOVENORMAL /D R:\\scanner\\icecast /MIN R:\\scanner\\icecast\\bin\\icecast.exe -c R:\\scanner\\icecast\\icecast.xml");
system("start /D R:\\scanner\\adsb /MIN R:\\scanner\\adsb\\start_1090.bat");
sleep 3;
system("start /D R:\\scanner\\adsb\\mlat-client-master /MIN python mlat-client  --input-type dump1090 --input-connect localhost:30005 --lat 45.135880 --lon -93.170720 --alt 800ft --user imago --server feed.adsbexchange.com:31090 --no-udp --results beast,connect,localhost:31004");
system('start /MIN /D "R:\\scanner\\VirtualRadar" VirtualRadar.exe');
sleep 3;
system("start /D R:\\scanner\\adsb /MIN R:\\scanner\\adsb\\start_978.bat");
print "deleting old crap...\n";
system("rmdir /Q /S R:\\scanner\\SDRTRunk\\recordings");
system("rmdir /Q /S C:\\ramdisk\\scanner\\SDRTRunk\\recordings");
system("del /Q R:\\scanner\\altacast\\altacaststandalone.log");
system("del /Q R:\\scanner\\altacast\\stream.log");
system("del /Q R:\\scanner\\altacast\\router.log");
system("del /Q R:\\scanner\\altacast\\sensor.log");
system("del /Q R:\\scanner\\altacast\\40D.txt");
system("del /Q R:\\scanner\\altacast\\402.txt");
system("mkdir R:\\scanner\\SDRTRunk\\recordings");
system("rmdir /Q /S R:\\scanner\\SDRTRunk\\event_logs");
system("rmdir /Q /S R:\\scanner\\SDRTRunk\\logs");
system("rmdir /Q /S R:\\scanner\\SDRTRunk\\streaming");
print "starting apps\n";
system("start Z:\\");
system("start /D R:\\scanner /MIN R:\\scanner\\launch.bat");
#system("start /ABOVENORMAL /MIN /D R:\\scanner java -XX:+UseParallelGC -Xmx4G -jar sdr-trunk-all-0.4.0-beta.2.jar");
system("start /ABOVENORMAL /MIN /D R:\\scanner\\sdr-trunk-0.4.0-beta.4.1\\bin R:\\scanner\\sdr-trunk-0.4.0-beta.4.1\\bin\\sdr-trunk.bat");
#-Djava.awt.1headless=true
sleep 1;
system("start /ABOVENORMAL /MIN /D R:\\scanner\\altacast R:\\scanner\\altacast\\altacastStandalone.exe");
sleep 5;
print "starting background music...\n";
system("start /BELOWNORMAL /MIN /D R:\\scanner launch2.bat");
print "starting watchdog...\n";
system("start /BELOWNORMAL /MIN /D R:\\scanner wperl tune.pl");
system("start /BELOWNORMAL /MIN /D R:\\scanner wperl ups.pl");
system("start /BELOWNORMAL /MIN /D R:\\scanner wperl stashd.pl");


my $now = time;
mkdir("D:\\cams\\$now");
mkdir("D:\\cams2\\$now");
mkdir("D:\\cams3\\$now");
mkdir("D:\\photos\\$now");
mkdir("D:\\photos2\\$now");
mkdir("D:\\photos3\\$now");

system("move D:\\cams\\*.mkv D:\\cams\\$now");
system("move D:\\cams2\\*.mkv D:\\cams2\\$now");
system("move D:\\cams3\\*.mkv D:\\cams3\\$now");
system("move D:\\photos\\*.jpg D:\\photos\\$now");
system("move D:\\photos2\\*.jpg D:\\photos2\\$now");
system("move D:\\photos3\\*.jpg D:\\photos3\\$now");

system("start /BELOWNORMAL /MIN /D R:\\scanner perl security3.pl");

system("start /BELOWNORMAL /MIN /D R:\\scanner R:\\scanner\\router.bat");

#system("Logman start connections");
#system("Logman start \"New Data Collector Set\"");

system('start /D R:\\scanner\\nginx R:\\scanner\\nginx\\nginx.exe');
system('start /D R:\\scanner fcgid.bat');

open(PASS,"R:\\scanner\\key1.txt");
my $key1 = <PASS>;
close PASS;
open(PASS,"R:\\scanner\\key2.txt");
my $key2 = <PASS>;
close PASS;
system("curl http://sync.afraid.org/u/$key1/");
system("curl http://sync.afraid.org/u/$key2/");

#system('taskkill /FI "WINDOWTITLE eq Microsoft Visual C++ 2017*" /IM * /F');
sleep 1;

system('start /MIN /D "R:\\scanner\\PeerBlock" perl dynallow.pl');
sleep 5;

#system("net start Apache2.2");

 $ss->speak("scanner is back online!"); 
`powershell New-SMBShare -Name "R" -Path "R:\" -FullAccess "user"`;

print "sleeping...\n";
sleep 15;

#system("start E:\\min.bat");
`powershell (New-Object -ComObject Shell.Application).MinimizeAll()`;


print "Done!\n";