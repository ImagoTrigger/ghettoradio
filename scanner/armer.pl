open(LIST,"armer.txt");
my @lines = <LIST>;
open(OUT,">out.txt");
foreach (@lines) {
	my ($id,$tag,$desc,$use) = split(/\t/,$_);
	chomp $use;
	chop $use;
	chop $desc;
	my $hex = sprintf("%X", $id);
	if (length($hex) == 1) {
		$hex = "000$hex";
	}	
	if (length($hex) == 2) {
		$hex = "00$hex";
	}
	if (length($hex) == 3) {
		$hex = "0$hex";
	}	
	$desc =~ s/^\s+|\s+$//g;
	$use =~ s/^\s+|\s+$//g;
	$desc =~ s/\"/\'/gi;
	$desc =~ s/![:alnum:]//gi;
	$desc =~ s/\&/\&amp;/gi;
print OUT qq{<alias color="-16777216" group="$use" iconName="No Icon" list="armer" name="$tag $desc"><id xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="priority" priority="100"/><id xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="talkgroupID" talkgroup="$hex"/></alias>
};
}
close OUT;