#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;

use lib "$FindBin::Bin/../lib";
use lib "$FindBin::Bin";

use Text::Indent::Simple;
my $indent = Text::Indent::Simple->new(
	eol	=> 1,
	size	=> 1,
	level	=> 2,
);

print $indent->item("| after init");
$indent->over(3);
print $indent->item("| after over");
print $indent->over->item("> over locally");
print $indent->item("| next text");
print $indent->back->item("< back locally");
print $indent->item("| next text");
$indent->reset;
print $indent->item("| after reset");
