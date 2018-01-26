package Foo;

use strict;
use warnings;

use Text::Indent::Simple;

sub greet {
	my $i = $Text::Indent::Simple::indent;
	print $i->indent("I am Foo");
}

1;
