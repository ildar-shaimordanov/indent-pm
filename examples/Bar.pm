package Bar;

use strict;
use warnings;

use Text::Indent::Simple;

sub greet {
	print Text::Indent::Simple->instance->item("Hello! I am Bar");
}

1;
