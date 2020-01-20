package Text::Indent::Simple;

use strict;
use warnings;

our $VERSION = "0.4";

our $DefaultSpace = " ";
our $DefaultSize = 4;

our $indent;

# =========================================================================

# Clamp a value on the edge, that is minimum. 
# So the value can't be less than this restriction.

sub lclamp {
	my ( $min, $v ) = @_;
	$v < $min ? $min : $v;
}

# Set the valid level and evaluate the proper indentation.

sub set_indent {
	my $self = shift;
	my $v = shift // 0;

	if ( defined wantarray ) {
		$self = bless { %{ $self } }, ref $self;
	}

	$self->{level} = lclamp($self->{initial}, $self->{level} + $v);
	$self->{indent} = $self->{text} x $self->{level};

	return $self;
}

# =========================================================================

sub new {
	my $class = shift;
	my %p = @_;

	my $t = $DefaultSpace;
	my $s = $DefaultSize;

	my $self = bless {
		text	=> $p{text} // ( $p{tab} ? "\t" : $t x lclamp(1, $p{size} // $s) ),
		eol	=> $p{eol},
		level	=> 0,
		initial	=> lclamp(0, $p{level} // 0),
	}, $class;

	$self->set_indent;

	$indent = $self if $p{propagate};

	return $self;
}

# =========================================================================

use overload (
	'""' => sub {
		shift->{indent};
	},
);

# =========================================================================

sub import {
	my $pkg = shift;
	$indent = $pkg->new(@_) if @_;
}

# =========================================================================

sub item {
	my $self = shift;
	my $e = $self->{eol} && ! $\ ? "\n" : "";
	join($e || $\ || "", map { "$self->{indent}$_" } @_) . $e;
}

sub reset {
	my $self = shift;
	$self->set_indent($self->{initial} - $self->{level});
}

sub over {
	my $self = shift;
	$self->set_indent(+abs(shift // 1));
}

sub back {
	my $self = shift;
	$self->set_indent(-abs(shift // 1));
}

1;

# =========================================================================

# EOF
