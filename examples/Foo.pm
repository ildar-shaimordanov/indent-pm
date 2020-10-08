package Foo;

use strict;
use warnings;

use Text::Indent::Tiny;

sub greet {
	print Text::Indent::Tiny->instance->item("Hello! I am Boo");
}

1;
