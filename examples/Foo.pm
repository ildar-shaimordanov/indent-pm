package Foo;

use strict;
use warnings;

use Text::Indent::Simple;

sub greet {
	print Text::Indent::Simple->instance->item("Hello! I am Boo");
}

1;
