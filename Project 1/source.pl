#-------------------------------------------------------------------------------
# (CS 480-01) (FA18) MOBILE DIGITAL FORENSICS
#                Project 1
#               Submitted By
#           Ashok Kumar Shrestha
#
# Description:
# ============
# Perl script to parse out email addresses and phone numbers from the data files.
#--------------------------------------------------------------------------------

#!/usr/bin/perl
use strict;
use warnings;

#path to input file (raw or dd)
my $infile = '../usb256.raw';

main();

sub display_errors{
	print("Error! Incorrect syntax!\n\n");
	print("Usage:\nperl filename.pl -[phonenumbers | emails]*\n\n");
	print("Examples:\n");
    print("python filename.pl\n");
    print("python filename.pl -emails\n");
    print("python filename.pl -phonenumbers\n");
    print("python filename.pl -emails -phonenumbers\n");
    print("python filename.pl -phonenumbers -emails\n");
}

sub fetch_emails{
	print("\nFetching emails ...\n");
	my $regex_pat = '(\w+(\.\w+)*@\w+(\.\w+)*\.[a-zA-Z]{2,3})';
	check_file($regex_pat,"emails.txt");
}

sub fetch_numbers{
	print("\nFetching phone numbers ...\n");
	my $regex_pat = '([\(]?\d{3}[\)]?[\-\.\ ]\d{3}[\-\.\ ]\d{4})\b';
	
	check_file($regex_pat,"phones.txt");
}

sub fetch_emails_numbers{
	print("Fetching emails and phonenumbers ...\n");
	fetch_emails();
	fetch_numbers();
}

sub check_file{
	my ($regex_pat,$outfile)= @_;
	open(my $file, '>', $outfile) or die "Could not open file '$outfile' $!";
	open(my $infiles, $infile) or die "Could not open file '$infile' $!";

	my $cnt = 0;
	
	while(<$infiles>){
		if(/$regex_pat/gi){
			print $file "[$1]\n";
			$cnt += 1;
		}
	}

	if($cnt>0){
		print("Match found: $cnt.\n");
		print("Unique Match: ");
		system("Cat $outfile | sort | uniq | wc -l");
		print("Output written to $outfile.\n");
	}else{
		print("No match found.\n");
	}

	close($infiles) or die "Could not close file: $infile.";
	close($file) or die "Could not close file: $outfile.";
}

sub main{
	print "----------------------------------------------------------------------------\n";
	
	my $num_of_params = @ARGV;
	if($num_of_params==0 ){
		fetch_emails_numbers();
	}elsif($num_of_params==1 and $ARGV[0]eq "-emails"){
		fetch_emails();
	}elsif($num_of_params==1 and $ARGV[0] eq "-phonenumbers"){
		fetch_numbers();
	}elsif($num_of_params==2){
		if(($ARGV[0] eq "-phonenumbers" and $ARGV[1] eq "-emails") or ($ARGV[1] eq "-phonenumbers" and $ARGV[0] eq "-emails")){
			fetch_emails_numbers();
		}else{
			display_errors();
		}
	}else{
		display_errors();
	}

	print "----------------------------------------------------------------------------\n";
}