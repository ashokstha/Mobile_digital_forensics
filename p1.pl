#!/usr/bin/perl
use strict;
use warnings;

sub display_errors{
	print "Error! Incorrect syntax!\n";
	print("Use...\nperl filename.pl -(phonenumbers | emails) -[phonenumbers | emails]\n")
}

sub fetch_emails{
	print "Fetching emails ...\n";
	print "Reg expr: \n";
}

sub fetch_numbers{
	print "Fetching phonenumbers ...\n";
	my $expr = "^[[0-9]{3}[-]?]{2}[0-9]{4}\$";
	print "Reg expr: $expr\n";
}

sub fetch_emails_numbers{
	print "Fetching emails and phonenumbers ...\n";
}

my $num_of_params = @ARGV;
print "----------------------------------------------------------------------------\n";
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