#-------------------------------------------------------------------------------
# (CS 480-01) (FA18) MOBILE DIGITAL FORENSICS
# 				 Project 1
# 			   Submitted By
# 			Ashok Kumar Shrestha
#
# Description:
# ============
# Perl script to parse out email addresses and phone numbers from the data files.
#--------------------------------------------------------------------------------

#!/usr/bin/perl
use strict;
use warnings;

my $filename = '../usb256.raw';
my $infile;
my $file;
my $outfile = 'result.txt';

print "----------------------------------------------------------------------------\n";
read_data();
main();
close_data();
print "----------------------------------------------------------------------------\n";

sub display_errors{
	print("Error! Incorrect syntax!\n\n");
	print("Usage:\nperl filename.pl -[phonenumbers | emails]*\n\n");
	print("Examples:\n");
    print("python filename.py\n");
    print("python filename.py -emails\n");
    print("python filename.py -phonenumbers\n");
    print("python filename.py -emails -phonenumbers\n");
    print("python filename.py -phonenumbers -emails\n");
}

sub read_data{
	open($infile, $filename)or die "Could not open file '$filename' $!";
	open($file, '>', $outfile) or die "Could not open file '$outfile' $!";
}

sub close_data{
	close($file) or die "Could not close file: $file.";
	close($infile) or die "Could not close file: $infile.";
}

sub fetch_emails{
	print("Fetching emails ...\n");
	my $regex_pat = '(\w+\@\w+\.\w+)';
	check_file("Email",$regex_pat);
}

sub fetch_numbers{
	print("Fetching phone numbers ...\n");
	my $regex_pat = '([[\+]?\d{1,3}]?[\-\.\(]?\d{3}[\-\.\)]?\d{3}[\-\.]?\d{4})';
	check_file("Phone",$regex_pat);
}

sub fetch_emails_numbers{
	print("Fetching emails and phonenumbers ...\n");
	my $emails = '(\w+\@\w+\.\w+)';
	my $numbers = '([[\+]?\d{1,3}]?[\-\.\(]?\d{3}[\-\.\)]?\d{3}[\-\.]?\d{4})';
	check_file("Email",$emails,"Phone",$numbers);
}

sub check_file{
	my $cnt = 0;
	my $num_of_params = @_;
	my ($current_search, $regex_pat, $next_search, $next_pat) = @_;
	
	while(<$infile>){
		if(/$regex_pat/gi){
			print $file "$current_search: [$1]\n";
			$cnt += 1;
		}elsif($num_of_params>2){
			if(/$next_pat/gi){
				print $file "$next_search: [$1]\n";
				$cnt += 1;
			}
		}
	}

	if($cnt>0){
		print("Match found: $cnt.\n");
		print("Output written to $outfile.\n");
	}else{
		print("No match found.\n");
	}
}

sub main{
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
}