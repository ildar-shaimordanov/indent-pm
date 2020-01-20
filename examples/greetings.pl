#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;

use lib "$FindBin::Bin/../lib";
use lib "$FindBin::Bin";

use Text::Indent::Simple (size => 1, eol => 1);

my $indent = $Text::Indent::Simple::indent;

$indent->over;

use Foo;
Foo::greet;

print $indent->item("Hello, Foo!");

$indent->over;

use Bar;
Bar::greet;

print $indent->item("Hello, Bar!");

$indent->reset;
print $indent->item("Hello, World!");
