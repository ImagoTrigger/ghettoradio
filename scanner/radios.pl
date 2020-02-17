open(LIST,"radios.txt");
my @lines = <LIST>;
open(OUT,">out.txt");
foreach (@lines) {
	if ($_ =~ /(\d+) (.*)/) {
		my $desc = $2;
		$desc =~ s/^\s+|\s+$//g;
		$desc =~ s/\"/\'/gi;
		$desc =~ s/![:alnum:]//gi;
	$desc =~ s/\&/\&amp;/gi;
	my $hex = sprintf("%X", $1);
	if (length($hex) == 1) {
		$hex = "00000$hex";
	}	
	if (length($hex) == 2) {
		$hex = "0000$hex";
	}
	if (length($hex) == 3) {
		$hex = "000$hex";
	}
	if (length($hex) == 4) {
		$hex = "00$hex";
	}	
	if (length($hex) == 5) {
		$hex = "0$hex";
	}		
		print OUT qq{<alias color="-16777216" group="Radios" iconName="No Icon" list="armer" name="$desc"><id xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="talkgroupID" talkgroup="$hex"/></alias>
	}
};
}
close OUT;