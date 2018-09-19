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
my $result = 'result.txt';

main();

sub main{
	print("\nStart processing...\n\n");

	open(my $infiles, "<:encoding(latin1)", $infile) or die "Could not open file '$infile' $!";
	open(my $file, '>', $outfile) or die "Could not open file '$outfile' $!";
	open(my $result_file, '>', $result) or die "Could not open file '$result' $!";

	my $dir = `mkdir jji 2>/dev/null`;

	my $display = "+-------+------------------------------------+------------+\n";
	print($result_file $display);
	print($display);

	$display = "|  S.N. |                Hash                |    Size    |\n";
	print($result_file $display);
	print($display);

	$display = "+-------+------------------------------------+------------+\n";
	print($result_file $display);
	print($display);

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

				# save the file
				my $save = `dd if=$outfile of=jji/file_$cnt.jji 2>/dev/null`;

				my $md = `MD5 $outfile | cut -d " " -f4`;
				my $size = `ls -l $outfile | cut -d " " -f8`;
				chomp($md);
				chomp($size);

				$display = sprintf("| %4d. |  %20s  |  %8d  |",$cnt, $md, $size);
				print($result_file $display);
				print($display);

				$display = "\n+-------+------------------------------------+------------+\n";
				print($result_file $display);
				print($display);
				
				open($file, '>', $outfile) or die "Could not open file '$outfile' $!";

			}else{
				print($file "$_");
			}
		}
	}

	close($file) or die "Could not close file: $outfile.";
	close($infiles) or die "Could not close file: $infile.";

	print("\nNo. of matches: $cnt\n\n");
}