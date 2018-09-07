#!/usr/bin/perl
use strict;
use warnings;

my $num_of_params = @ARGV;

if($num_of_params>2){
	print "Error! Incorrect syntax!\n";
	print("Use...\nperl filename.pl -(phonenumbers | emails) -[phonenumbers | emails]\n")
}else{
	if($num_of_params==1){
		my $param0 = $ARGV[0];
		my $expr;
		if($param0 eq "-phonenumbers"){ 
			print "Fetching phonenumbers ...\n";
			$expr = "^[[0-9]{3}[-]?]{2}[0-9]{4}\$";
			print "Reg expr: $expr\n"
		}elsif($param0 eq "-emails"){
			print "Fetching emails ...\n";
			#$expr = "^[\w]+[\.\-]*[\w]*@[\w]+\.[\w]{1,3}\$";
			print "Reg expr: \n"
		}
	}else{
		if($num_of_params==2){
			my $param0 = $ARGV[0];
			my $param1 = $ARGV[1];
			if(not (($param0 eq "-phonenumbers" and $param1 eq "-emails") or ($param1 eq "-phonenumbers" and $param0 eq "-emails"))){
				print "Error! Incorrect syntax!\n";
				print("Use...\nperl filename.pl -(phonenumbers | emails) -[phonenumbers | emails]\n")
			}
		}

		print "Fetching phonenumbers and emails ...\n";
	}
}
