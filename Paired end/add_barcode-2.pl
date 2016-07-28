#!/usr/bin/perl
use strict; use warnings;
use Data::Dumper;
use Benchmark qw(:hireswallclock); # to check execution time 
use Getopt::Long;

#####################################################################################################################
# This script is to take a SAM format file from Tophat (without barcode tag information) and return BC:Z:NNNNN tag
# Input is a SAM file and a fastq file (R1)
#                                                   written by Jungeui Hong 08/16/2014 Version v1.0
########################################################################################################

###########################################
# Take the starting time of this operation
###########################################
my $starttime = Benchmark->new;
my $finishtime;
my $timespent;

##################################################################
# Input arguments : input SAM format file / number of mismatches #
##################################################################
my $sam;     # input NNN.sam
my $fq;      # input NNN_R1.fastq

GetOptions(
    'sam=s'=>\$sam,
    'fq=s'=>\$fq, 
    );

###############################################################################################
# Read FASTQ and make an hash of READ ID (KEY) => BARCODE (VALUE)
###############################################################################################
open(FQ, "<$fq") or die "No such a input FASTQ file!\n";
my %fq=();

while(<FQ>){  
    chomp;
    my @tmp_string=split(/ /,$_);
    if ($_ =~ /^\@HWI/ || $_=~/^\@M02455/){  # if this line is a new read header line: HWI - Hiseq, M - Miseq
	my @tmp_read_ID=split(/\@/,$tmp_string[0]);
	my @tmp_barcode=split(/\:/,$tmp_string[1]);
	$fq{$tmp_read_ID[1]}=$tmp_barcode[3];
    }
    
}
print "READING FASTQ FILE IS DONE!!!\n";

########################################################################
# READ THE ORIGINAL SAM FILE AND RETURN THE BARCODE-INFO ADDED SAM FILE
########################################################################
my @file_name=split(/\./, $sam);
my $out=$file_name[0].".bc.sam";
open OUT, ">$out";

open(SAM, "<$sam") or die "No such an input SAM file!\n";

while(<SAM>){
    chomp;
    if($_ =~ /^HWI/ || $_ =~/^M02455/){ # IF THIS LINE IS A NEW SAM ALIGNMENT READ : HWI- HISEQ / M-MISEQ
	my @tmp_string=split(/\t/, $_);
	if($fq{$tmp_string[0]}){ # if this READ ID HAS A VALUE (BARCODE INFO) : DO NOT PRINT OUT READS WITHOUT BARCODES
	    my $tmp_barcode=$fq{$tmp_string[0]};
	    print OUT "$_\tBC:Z:$fq{$tmp_string[0]}\n";
	}
    }else{
	print OUT "$_\n"; # print headers
    }
}
close OUT;

###########################                                                                                                                                                        # Take the finishing time                                                                                                                                                          ###########################                                                                                                                                                        
$finishtime = Benchmark->new;
$timespent = timediff($finishtime,$starttime);
print "\nDone!\nSpent". timestr($timespent). "\n";

exit 0;
