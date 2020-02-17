#!/usr/bin/perl
# imagotrigger@gmail.com - create a SDRTrunk playlist V3 xml from all talkgroups on radioreference.com 
# see: https://www.radioreference.com/apps/db/
#  the only variable you need is "sid" or System ID from the RR database.
#   adjust the tail of your XML as necesssary... 
#   provide your own ignore.txt list if you wish othewise everything is set to record on the same priority!



my $sid = 3508; #change me!
my $list = "armer"; #change this to whatever your system name is, if you want


use common::sense;
use LWP::UserAgent;

open(IGNORE,"ignore.txt");
my @lines = <IGNORE>;
my @ignore;
foreach (@lines) {
	my ($id,$tag) = split(/\t/,$_);
	push(@ignore,$id);
}
close IGNORE;

my $url = "https://www.radioreference.com/apps/db/?sid=$sid&opt=all_tg";
my $ua = LWP::UserAgent->new;
my $req = HTTP::Request->new(GET => $url);
my $resp = $ua->request($req);
my $xml;

if ($resp->is_success) {
	my $message = $resp->decoded_content;
	$message =~ s/\n//gi;
	my $data;
	if ($message =~ /<b> Talkgroups<\/b>(.*)/) {
		$data = $1;
	}
	my @rows = split("<tr>",$data);
	my $pos = 0;
	foreach my $row (@rows) {
		$pos++;
		next if $pos < 3;
		my @cols = split("</td>",$row);
		my $dec; 
		if ($cols[0] =~ /<td class="td\d t" nowrap>(.*)/) { $dec = $1; $dec =~ s/\s//gi; }
		my $alpha; 
		if ($cols[3] =~ /<td nowrap class="td\d t">(.*)/) { $alpha = $1; }
		my $desc; 
		if ($cols[4] =~ /<td width="100%" class="td\d t">(.*)/) { $desc = $1; $desc =~ s/&nbsp;/ /gi; $desc =~ s/\s$//gi;}
		my $group; 
		if ($cols[6] =~ /<td nowrap class="td\d t">(.*)/) { $group = $1; $group =~ s/&nbsp;/ /gi; $group =~ s/\s$//gi;}
		
	
		$desc =~ s/^\s+|\s+$//g;
		$group =~ s/^\s+|\s+$//g;
		$desc =~ s/\"/\'/gi;
		$desc =~ s/![:alnum:]//gi;
		$desc =~ s/\&/\&amp;/gi;
		
		if (length($dec) == 1) {
			$dec = "000$dec";
		}	
		if (length($dec) == 2) {
			$dec = "00$dec";
		}
		if (length($dec) == 3) {
			$dec = "0$dec";
		}
		next if !$dec;
		my $record = qq{
		<id type="record"/>};
		my $pri = 69;
		if (grep $_ eq $dec, @ignore) {
		  $record = "";
		  $pri = "-1";
		}
		$xml .= qq{
		<alias name="$alpha $desc" color="-16777216" group="$group" list="$list" iconName="No Icon">
		 <id type="priority" priority="$pri"/>
		 <id type="talkgroup" value="$dec" protocol="APCO25"/>$record
		 </alias>};
	}
	print "Processed about $pos aliases\n";
}

open(PLAYLIST,">default.xml");

#the head
print PLAYLIST qq{<playlist version="3">};

#the aliases
print PLAYLIST $xml;

#the tail
print PLAYLIST qq{
  <channel name="ARMER_ANOKA" system="1" site="2" enabled="true" order="1">
    <record_configuration/>
    <source_configuration type="sourceConfigTunerMultipleFrequency" source_type="TUNER_MULTIPLE_FREQUENCIES">
      <frequency>853387500</frequency>
      <frequency>852887500</frequency>
      <frequency>851937500</frequency>
      <frequency>852387500</frequency>
    </source_configuration>
    <event_log_configuration/>
    <decode_configuration type="decodeConfigP25Phase1" traffic_channel_pool_size="30" ignore_data_calls="false" modulation="CQPSK"/>
    <aux_decode_configuration/>
    <alias_list_name>armer</alias_list_name>
  </channel>
  <channel name="ARMER_RAMSEY" system="1" site="2" enabled="true" order="2">
    <record_configuration/>
    <source_configuration type="sourceConfigTunerMultipleFrequency" source_type="TUNER_MULTIPLE_FREQUENCIES">
      <frequency>852087500</frequency>
      <frequency>853762500</frequency>
      <frequency>853712500</frequency>
      <frequency>853362500</frequency>
    </source_configuration>
    <event_log_configuration/>
    <decode_configuration type="decodeConfigP25Phase1" traffic_channel_pool_size="30" ignore_data_calls="false" modulation="CQPSK"/>
    <aux_decode_configuration/>
    <alias_list_name>armer</alias_list_name>
  </channel>
</playlist>
};
close PLAYLIST;
exit;




