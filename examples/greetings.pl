#!/usr/bin/env perl

use strict;
use warnings;

use FindBin;

use lib "$FindBin::Bin/../lib";
use lib "$FindBin::Bin";

use Text::Indent::Simple (text => ' ', eol => 1);

my $indent = $Text::Indent::Simple::indent;

$indent->over;

use Foo;
Foo::greet;

$indent->printf("Hello, Foo!");

$indent->over;

use Bar;
Bar::greet;

$indent->printf("Hello, Bar!");

$indent->reset;
$indent->printf("Hello, World!");
