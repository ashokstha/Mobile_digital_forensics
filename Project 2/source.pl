#-------------------------------------------------------------------------------
# (CS 480-01) (FA18) MOBILE DIGITAL FORENSICS
#                Project 2
#               Submitted By
#           Ashok Kumar Shrestha
#
# Description:
# ============
# Perl script to parse out .JJI (Josh Jones Image) Files from the data files.
#--------------------------------------------------------------------------------

#!/usr/bin/perl
use strict;
use warnings;

#path to input file (raw or dd)
#my $infile = '../../jji_project.dd';
my $infile = '../../sheep.dd';
my $outfile = 'result.jji';

main();

sub main{
	print "----------------------------------------------------------------------------\n";
	
	print("Start processing...\n");

	open(my $infiles, "<:encoding(latin1)", $infile) or die "Could not open file '$infile' $!";
	open(my $file, '>', $outfile) or die "Could not open file '$outfile' $!";

	my $cnt = 0;
	
	my $regex_start = '(.?J.?O.?S.?H.?(\s|.)*)';
	my $regex_end = '((\s|.)*J.?O.?N.?E.?S.?)';
	my $is_detect = 0;

	while(<$infiles>){
		if($is_detect eq 0){
			if(/$regex_start/gm){
				print($file "$1");
				$is_detect = 1;
			}
		}else{
			if(/$regex_end/gm){
				print($file "$1");
				$cnt += 1;
				$is_detect = 0;

				system("MD5 $outfile");
				#open($file, '>', $outfile) or die "Could not open file '$outfile' $!";

			}else{
				print($file "$_");
			}
		}
	}
	
	close($file) or die "Could not close file: $outfile.";
	close($infiles) or die "Could not close file: $infile.";

	print("No. of matches: $cnt\n");

	print "----------------------------------------------------------------------------\n";
}