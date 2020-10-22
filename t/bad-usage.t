#!perl -T
use 5.004;
use strict;
use warnings;
use Test::More;

# =========================================================================

plan tests => 3;

use Text::Indent::Tiny;

my $indent = Text::Indent::Tiny->new(
	size	=> 1,
);

$indent->over(3);

ok $indent,
	"Indent is 3 spaces";

ok $indent - 1,
	"Indent is 2 spaces: indent - value";

# Simulate bad usage of the indent instance
# Surround it with "eval" to avoid dying and complete the testing
$indent = eval { 5 - $indent };
ok $@ =~ /^No sense to subtract indent from number/,
	"Not allowed: value - indent";

# =========================================================================

# EOF
