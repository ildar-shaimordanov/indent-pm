package Indent;

use strict;
use warnings;

# =========================================================================

# Clamp a value on the edge, that is minimum. 
# So the value can't be less than this restriction.
sub _lclamp {
	my ( $min, $v ) = @_;
	$v < $min ? $min : $v;
}

# Set the valid level and evaluate the proper indentation.
sub _set_indent {
	my $p = shift;
	my $v = shift // 0;

	$p->{level} = _lclamp( 0, $p->{level} += $v );
	$p->{indent} = $p->{text} x $p->{level};
}

# Detect argument type and get the level value
sub _get_level {
	my $v = shift;
	ref $v eq __PACKAGE__ ? $v->{level} : $v;
}

# =========================================================================

sub new {
	my $class = shift;
	my %p = @_;

	my $self = {
		text => $p{text} // ( $p{tab} ? "\t" : " " x _lclamp( 1, $p{size} // 4 ) ),
		EOL => $p{eol} ? "\n" : $\,
		level => _lclamp( 0, $p{level} // 0 ),
	};

	_set_indent $self;

	bless $self, $class;
}

# =========================================================================

use overload (
	'=' => sub {
		my $self = shift;
		bless { %{ $self } }, ref $self;
	},
	'""' => sub {
		shift->{indent};
	},
	'++' => sub {
		_set_indent shift, +1;
	}, 
	'--' => sub {
		_set_indent shift, -1;
	},
	'+' => sub {
		my $self = shift;
		my $v = shift;

		my %self = %{ $self };
		_set_indent \%self, +_get_level($v);

		bless { %self }, ref $self;
	},
	'-' => sub {
		my $self = shift;
		my $v = shift;

		my %self = %{ $self };
		_set_indent \%self, -_get_level($v);

		bless { %self }, ref $self;
	},
);

# =========================================================================

sub import {
	shift;
	goto &config if @_;
}

# =========================================================================

my $indent;

sub config {
	$indent = __PACKAGE__->new(@_);
}

sub reset {
	$indent = $indent - $indent;
}

sub over {
	$indent++;
}

sub back {
	$indent--;
}

sub print {
	my $self = ref $_[0] eq __PACKAGE__ ? shift : $indent;

	local $\ = $self->{EOL};
	CORE::print $self, @_;
}

sub vprint {
	my $self = shift;

	local $\ = $self->{EOL};
	CORE::print $self, $_ for ( @_ );
}

sub printf {
	my $self = ref $_[0] eq __PACKAGE__ ? shift : $indent;

	$self->print(sprintf shift // "", @_);
};

1;

# =========================================================================

# EOF
