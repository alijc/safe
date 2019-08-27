#!/usr/bin/perl -w

# use module
use XML::Simple;
use Data::Dumper;
use strict;

my $puznum = shift( @ARGV );

# create object
my $xml = new XML::Simple;

# read what we need out of the XML file
my $data = $xml->XMLin($puznum . "crp.xml");
my $metadata    = $data->{"rectangular-puzzle"}->{"metadata"};
my $crossword   = $data->{"rectangular-puzzle"}->{"crossword"};
my $grid        = $crossword->{"grid"};
my $title       = nulltermstring( $metadata->{"title"} );
my $creator     = nulltermstring( $metadata->{"creator"} );
my $copyright   = nulltermstring( $metadata->{"copyright"} );
my $width       = $grid->{"width"};
my $height      = $grid->{"height"};
my @cell        = $grid->{"cell"};
my @across      = ($crossword->{"clues"})[0][0]->{clue};
my @down        = ($crossword->{"clues"})[0][1]->{clue};
my $numclues = 0;
for (my $i=0; $i<length( $across[0] ) && defined $across[0][$i]; $i++) {
	$numclues++;
}
for (my $i=0; $i<length( $down[0] ) && defined $down[0][$i]; $i++) {
	$numclues++;
}

# Assemble the pieces
my $cib = pack("ccvx4", $width, $height, $numclues);

my $solution = doboard( 0, $width, $height, @cell ); # Solution
my $state    = doboard( 1, $width, $height, @cell ); # and player state

# the clues
my @clueArray = doclues( $across[0], $down[0] );
my $clues;
foreach my $clue (@clueArray) {
	$clues .= pack("a*x", $clue);
}

# Calculate the checksums
my $checksum = 0;
my $cibcksum = cksumregion( $cib, 8, 0 );
$checksum = cksumregion( $solution, ($width * $height), $cibcksum );
$checksum = cksumregion( $state, ($width * $height), $checksum );
$checksum = cksumstring( $title, $checksum );
$checksum = cksumstring( $creator, $checksum );
$checksum = cksumstring( $copyright, $checksum );
foreach my $clue (@clueArray) {
	$checksum = cksumstring( $clues, $checksum );
}

my $c_cib = cksumregion( $cib, 8, 0 );
my $c_sol = cksumregion( $solution, ($width * $height), 0 );
my $c_grid = cksumregion( $state, ($width * $height), 0 );

my $c_part = 0;
$c_part = cksumstring( $title, $c_part );
$c_part = cksumstring( $creator, $c_part );
$c_part = cksumstring( $copyright, $c_part );
foreach my $clue (@clueArray) {
	$c_part = cksumstring( $clue, $c_part );
}

my $lo_cib  = hex("49") ^ ($c_cib  & hex("ff"));
my $lo_sol  = hex("43") ^ ($c_sol  & hex("ff"));
my $lo_grid = hex("48") ^ ($c_grid & hex("ff"));
my $lo_part = hex("45") ^ ($c_part & hex("ff"));

my $hi_cib  = hex("41") ^ (($c_cib  & hex("ff00")) >> 8);
my $hi_sol  = hex("54") ^ (($c_sol  & hex("ff00")) >> 8);
my $hi_grid = hex("45") ^ (($c_grid & hex("ff00")) >> 8);
my $hi_part = hex("44") ^ (($c_part & hex("ff00")) >> 8);

# Write it all out
open(PUZ, ">:raw", $puznum . ".puz") or die "Unable to open: $!";

print PUZ pack("va12", $checksum, "ACROSS&DOWN");
print PUZ pack("vCCCCCCCCx20", $cibcksum, 
	       $lo_cib, $lo_sol, $lo_grid, $lo_part,
	       $hi_cib, $hi_sol, $hi_grid, $hi_part);
print PUZ $cib;
print PUZ $solution;
print PUZ $state;
print PUZ $title;
print PUZ $creator;
print PUZ $copyright;
print PUZ $clues;
print PUZ pack("x");

close(PUZ);
exit;

sub doboard { 
	my ($isstate, $width, $height, @in ) = @_; my $board;

	for (my $x=0; $x<$width; $x++) {
		for (my $y=0; $y<$height; $y++) {
			my $index = $y*$height + $x;
			if ( ! exists($in[0][$index]->{solution}) ) { $board .= "."; }
			elsif ( $isstate )							{ $board .= "-"; }
			else 				{ $board .= $in[0][$index]->{solution}; }
		}
	}
	return $board;
}

sub doclues {
	my ($across, $down) = @_;
	my @array;
	my $text;

	# Pull the clues out of their separate sections and into a single array.
	for (my $i=0; $i<length( $across[0] ) && defined $across[0][$i]; $i++) {
		push @array, $across[0][$i];
	}
	for (my $i=0; $i<length( $down[0] ) && defined $down[0][$i]; $i++) {
		push @array, $down[0][$i];
	}

	# Sort the array on the clue number.
	@array = sort { $a->{number} <=> $b->{number} } @array;

	# And format each clue the way we want it.
	@array = map {&formatclue} @array;
	#print Dumper(@array);

	return @array;
}

sub formatclue {
    my $cluenum = $_->{number};
    my $cluetext = $_->{content};
    my $cluefmt = $_->{format};
    return "$cluenum. $cluetext ($cluefmt)";
}


sub cksumregion {
    my ($data, $len, $cksum ) = @_;
    my @dataArray = split( //, $data);
    my $i;

    for ($i = 0; $i < $len; $i++) {
    	if ( $cksum & 0x0001 ) { $cksum = ($cksum >> 1) + 0x8000; }
		else                   { $cksum =  $cksum >> 1; }

     	$cksum += ord $dataArray[$i];
    }

    return $cksum;
}

sub nulltermstring {
	my $string = shift @_;
	return pack("a*x", $string );
}


sub cksumstring {
	my ( $string, $checksum ) = @_;

	if ( length($string) <= 1 ) { return $checksum; }

	return cksumregion( $string, length( $string ), $checksum );
}
