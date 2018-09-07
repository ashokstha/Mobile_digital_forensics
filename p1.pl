#!/usr/bin/perl
use strict;
use warnings;

my $filename = '../usb256.raw';
my $myfile;
my $num_of_params = @ARGV;
print "----------------------------------------------------------------------------\n";
read_data();
main();
close_data();
print "----------------------------------------------------------------------------\n";

sub display_errors{
	print "Error! Incorrect syntax!\n";
	print("Use...\nperl filename.pl -(phonenumbers | emails) -[phonenumbers | emails]\n")
}

sub read_data{
	open($myfile, $filename)
  	or die "Could not open file '$filename' $!";
}

sub close_data{
	close($myfile)
	or die "Could not close file.";
}

sub fetch_emails{
	print "Fetching emails ...\n";
	print "Reg expr: \n";

	while(<$myfile>){
		if(/(\w+\@\w+\.\w+)/gi){
			print "Email: [$1]\n";
		}
	}
}

sub fetch_numbers{
	print "Fetching phonenumbers ...\n";
	my $expr = "^[[0-9]{3}[-]?]{2}[0-9]{4}\$";
	print "Reg expr: $expr\n";
}

sub fetch_emails_numbers{
	print "Fetching emails and phonenumbers ...\n";
}

sub main{
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