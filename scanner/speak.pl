    use Speech::Synthesis;
    my $engine = 'SAPI5'; # or 'SAPI4', 'MSAgent', 'MacSpeech' or 'Festival' 
    my @voices = Speech::Synthesis->InstalledVoices(engine => $engine);
#  my @avatars = Speech::Synthesis->InstalledAvatars(engine => $engine);
    foreach my $voice (@voices)
    {
    	if ($voice->{id} =~ /Zira|Anna/i) {
        my %params = (  engine   => $engine,
                        avatar   => undef,
                        language => $voice->{language},
                        voice    => $voice->{id},
                        async    => 0
                        );
        my $ss = Speech::Synthesis->new( %params );
        $ss->speak($ARGV[0]);
        print "played";
        }
    }