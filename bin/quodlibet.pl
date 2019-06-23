#!/usr/bin/perl

use Music::ABC::Archive;


my $beatsPerMeas = 4 * $ARGV[0];
my $abcfile = $ARGV[1];

#                    CMaj(I) Dmin(ii) Emin(iii) FMaj(IV) GMaj(V) Amin(vi)
my @CONSONANCES = ( "CEG",   "ADF",  "BEG",     "ACF",   "BDG", "ACE" );

my %songlist = ();

makeSonglist( $abcfile );

my $x, $y, $z, $m, $n;

my @keys = sort keys %songlist;

foreach $x ( @keys ) {
	foreach $y ( grep !/$x/, @keys ) {
		foreach $z ( grep !/$x|$y/, @keys ) {
			for ( $m=0; $m<length $songlist{$x}; $m+=$beatsPerMeas ) {
				for ( $n=$m; $n<length $songlist{$x}; $n+=$beatsPerMeas ) {
					tallyConsonance($songlist{$x},
									rotateSong( $m, $songlist{$y}),
									rotateSong( $n, $songlist{$z}) );
					print "  $x, $y+$m, $z+$n\n";
				}
			}
		}
	}
}


# Rotate the song by the requested number of beats.
# (As if creating the second part of a round.)
sub rotateSong
{
	my ( $num, $song ) = @_;
	if ( $num == 0 ) { return $song; };

	# Grab the right amount of song off of the end, truncating it.
	my $chunk = substr( $song, -$num, $num, "" );

	# and attach it to the front of the song.
	return $chunk . $song;
}

sub makeSonglist
{
	my $abcfile = shift @_;

	my $abcArch = Music::ABC::Archive->new($abcfile);
	$abcArch->openabc($abcfile) || die("failed to open $abcfile"); 

	my @songs = $abcArch->list_by_title() ;
 
	foreach (@songs) {
		my ($display_name, $sn, $type, $meter, $key, $titles_aref) = @{$_} ;
		###print "$display_name\n";

		# Get the entire song
		my @song = $abcArch->get_song($sn);	

		my $song = normalizeSong( @song );

		$songlist{$sn} = $song;

		###print "$sn - $song\n\n";
	}
}

# Normalize the song, turning it into a string of note values.
sub normalizeSong 
{
	my @song = @_;

	# Strip off comments
	@song = grep !/^%/, @song;

	# ..and the header fields
	@song = grep !/[A-Za-z]:/, @song;

	# What's left are the notes.  Join them into a single string.
	$song = join "", @song;

	# Push every note into the same A-G octave
	$song =~ s/[,']//g;
	$song =~ tr/a-z/A-Z/;

	# Remove any spaces, ties and slurs, and collapse any double bars.
	$song =~ s/[ \-()]//g;
	$song =~ s/\|\|/|/g;

	# Replace every long note with an equal number of short ones.
	my @notes = split //, $song;
	foreach (@notes) {
		if (/\d/) { $_ = $last x ($_ - 1); }
		$last = $_;
	}
	$song = join "", @notes;
	# If there's an anacrusis, roll it over into the last measure.
	$song =~ s/^[zZ]+//;			# First, remove leading rests.
	$song =~ s/^([A-G]+)\|/|/;		# Remove and save the anacrusis.
	my $anacrusis = $1;
	$song =~ s/\|([A-GZ]+)\|$/|/;	# Remove and save the last measure.
	my $lastmeas = $1;
									# Pad the last measure to its full length.
	$lastmeas = $lastmeas . 'Z' x ($beatsPerMeas - length($lastmeas));	
	if ( length($anacrusis)) {		# Overlay the anacrusis onto the end.
		$length = 0 - length($anacrusis);
		substr($lastmeas, $length) = $anacrusis;
	}
	$song .= $lastmeas . '|';

	# Finally, wipe out all of the rests, and all the bar lines.
	$song =~ s/[zZ]/./g;
	$song =~ s/\|//g;

	return $song;
}

sub tallyConsonance
{
	my ( @songs ) = @_;
	my $i, $j;
	my @tally;			# a tally of consonances

	# Tally up the individual consonances for each time unit of this songs.
	for ( $i=0; $i<length $songs[0]; $i++ ) {

		# For each beat(let), gather up the note from each song
		# (in a hash, to enforce uniqueness), and remove any rests. 
		my %notes = ();
		foreach $song (@songs) {
			$notes{substr( $song, $i, 1 )} = 1;
		}
		delete $notes{"."};

		# Compile into a regular expression.
		my $regexp = join ".*", sort keys %notes;

		# Run through the list of consonances, marking this beat as 
		# consonant if it finds any matches.
		$tally[$i] = 0;
		foreach (@CONSONANCES) {
			if ( /$regexp/ ) { $tally[$i] = 1; last; };
		}
	}

	# Weight each note according to its position.  (Downbeats weigh more than upbeats...)
	for ( $j=4; $j<=$beatsPerMeas; $j*=2 ) {
		for ( $i=0; $i<length $songs[0]; $i+=$j ) {
			$tally[$i] *= 2;
		}
	}

	# Calculate the total consonance.
	my $score = 0;
	for ( $i=0; $i<length $songs[0]; $i++ ) {
		$score += $tally[$i];
	}
	print "$score  ";

	# Only print the quarter note beats, and put the bar lines back in.
	for ( $i=0; $i<length $songs[0]; $i+=4 ) {
		print $tally[$i];
		if ( (($i+4) % 16) == 0 ) { print "|"; }
	}

	return $score;
}
