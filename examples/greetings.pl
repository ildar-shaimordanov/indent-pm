#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;

use lib "$FindBin::Bin/../lib";
use lib "$FindBin::Bin";

use Text::Indent::Simple (
	size	=> 2,
	eol	=> 1,
);

my $indent = Text::Indent::Simple->instance;

print $indent->item("Start greetings...");

print $indent->item("Hello, World!");

$indent->over;

use Foo;
Foo->greet;

print $indent->over->item("Hello, Foo!");

use Bar;
Bar->greet;

print $indent->over->item("Hello, Bar!");

$indent->reset;

print $indent->item("Finished...");
