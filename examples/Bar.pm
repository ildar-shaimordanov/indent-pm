package Bar;

use strict;
use warnings;

use Text::Indent::Simple;

sub greet {
	print $Text::Indent::Simple::indent->item("I am Bar");
}

1;
