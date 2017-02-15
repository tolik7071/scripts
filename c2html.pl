#!/usr/bin/perl

$text = "This is a first line.\nSecond line <here>.\nI & my friend\n";
print $text;

$text =~ s/&/&amp;/g; # should be first
$text =~ s/</&lt;/g;
$text =~ s/>/&gt;/g;
print $text;

$text = "This is my email: tolik.goodz@smk.com !!!\n";
$text =~ s{
\b
(
	\w[-.\w]*
	\@
	[-a-z0-9]+(\.[-a-z0-9]+)*\.(com|edu|info)
)
\b
}{<a href="mailto:$1">$1</a>}gix;
print $text;

$text = "My page is http://smk.com/tolik!!!\n";
$text =~ s{
\b
(
	http://[-a-z0-9]+(\.[-a-z0-9]+)*\.(com|edu|info)\b
	(
		/[-a-z0-9_:\@&?=+,.!/~*'%\$]*
		(?<![.,?!])
	)?
)
}{<a href="$1">$1</a>}gix;
print $text;

print "This \e[7mis a simple\e[m text."