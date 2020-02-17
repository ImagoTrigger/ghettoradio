use strict;
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
    
 $ss->speak("scanner is rebooting in ten seconds!"); 
  my $cmd = "perl R:\\scanner\\wwwroot\\stash.pl";
 system($cmd);
 sleep 7;
 $ss->speak("three"); 
 sleep 1;
 $ss->speak("two"); 
 sleep 1;
 $ss->speak("one"); 
 sleep 1;
 $ss->speak("rebooting now! the scanner will be back online shortly."); 

sleep 3;
system("TASKKILL /F /IM altacastStandalone.exe /T 2>nul");
 $cmd = "shutdown /r /t 3 /c \"scheduled scanner reboot\"";
 system($cmd);