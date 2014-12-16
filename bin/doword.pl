#!/usr/bin/perl -w
use strict;

my $word = $ARGV[0];
my $rword = reverse $word;
my $dict = "/usr/share/dict/words";

# read in the dictionary
open DICT, $dict or die "couldn't open $dict\n";
my @dict = <DICT>;
close DICT;

one_word( $word, @dict );
one_word( $rword, @dict );

two_words( $word, @dict );
two_words( $rword, @dict );

three_words( $word, @dict );
three_words( $rword, @dict );

bigger_than_one_word( $word, @dict );

# embedded in another word
sub one_word
{
    my ( $word, @dict ) = @_;
    print "\nSupersets of $word\n\n";
    my @list = grep /$word/, @dict;
    print @list;
}


# embedded in two adjacent words
sub two_words
{
    my ( $word, @dict ) = @_;

    print "\n";
    for ( my $i=1; $i < length $word; $i++ ) {
	my $word1 = substr( $word, 0, $i) . "\$";
	my $word2 = "^" . substr ($word, $i );
	my @list1 = grep /$word1/, @dict;
	my @list2 = grep /$word2/, @dict;
	if ( scalar(@list1) && scalar(@list2) ) {
	    print @list1 . " $word1  $word2 " . @list2 . "\n";
	}
    }
}

# embedded in three adjacent words
sub three_words
{
    my ( $word, @dict ) = @_;

    print "\n";
    for ( my $i=1; $i < length($word)-1; $i++ ) {
	for ( my $j=1; $j < length($word)-$i; $j++ ) {
	    my $word1 = substr( $word, 0, $i) . "\$";
	    my $word2 = "^" . substr ($word, $i, $j ) . "\$";
	    my $word3 = "^" . substr ($word, $i+$j );
	    my @list1 = grep /$word1/, @dict;
	    my @list2 = grep /$word2/, @dict;
	    my @list3 = grep /$word3/, @dict;
	    if ( scalar(@list1) and scalar(@list2) and scalar(@list3) ) {
		print @list1 . " $word1  $word2  $word3 " . @list3 . "\n";
	    }
	}
    }
}


# anagram a subset of another word
sub bigger_than_one_word
{
    my ( $word, @dict ) = @_;
    my @letters = split //, $word;

    print "\nSupersets of anagram of $word\n\n";
WORD:
    foreach my $orig (@dict) {
	chomp $orig;
	my $dword = $orig;
	foreach my $letter (@letters) {
	    $dword =~ s/$letter// || next WORD;
	}
	print "$orig\t - $dword\n";
    }
}
