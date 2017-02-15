#!/usr/bin/perl

$result = "by Jeffs Sun";
$result =~ s/(?<=\bJeff)(?=s\b)/'/g;
print "`$result`\n";

$pop = "465465487645135";
$pop =~ s/(?<=\d)(?=(?:\d\d\d)+$)/,/g;
print "The US population is $pop\n";

$pop = "Some value 465465487645135 is very big.";
$pop =~ s/(?<=\d)(?=(?:\d\d\d)+(?!\d))/,/g;
print "$pop\n";