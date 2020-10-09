#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;

use lib "$FindBin::Bin/../lib";
use lib "$FindBin::Bin";

use Text::Indent::Tiny;
my $indent = Text::Indent::Tiny->new;

$\ = "\n";

# Indent each line with 4 spaces (by default)
$indent->over;
print $indent->item(
	"To be or not to be",
	"That is the question",
);
$indent->back;

# Indent the particular line to 5th level (with 20 spaces)
$indent->over(5);
print $indent->item("William Shakespeare");
