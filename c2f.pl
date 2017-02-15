#!/usr/bin/perl

print "Enter a temperature (e.g., 32F, 100C):\n";
$input = <STDIN>; # Получить одну строку от пользователя.
chomp($input);    # Удалить из $input завершающий символ новой строки.
if ($input =~ m/^([-+]?[0-9]+(\.[0-9]*)?)\s*([CcFf])$/)
{
	$InputNum = $1;
	$type = $3;
	
	if ($type eq "C" or $type eq "c")
	{
		$celsius = $InputNum;
		$fahrenheit = ($celsius * 9 / 5) + 32;
	}
	else
	{
		$fahrenheit = $InputNum;
		$celsius = ($fahrenheit - 32) * 5 / 9;
	}
	
	printf "%.2f C is %.2f F\n", $celsius, $fahrenheit;
}
else
{
	print "Expecting a number followed by \"C\" or \"F\",\n";
	print "so I don't understand \"$input\".\n";
}
