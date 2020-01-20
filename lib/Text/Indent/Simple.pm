=head1 NAME

Text::Indent::Simple - simple and flexible indentation across modules

=head1 VERSION

This module version is 0.4.

=head1 SYNOPSIS

Simple usage

	use Text::Indent::Simple;
	my $indent = Text::Indent::Simple->new(
		eol	=> 1,
		size	=> 1,
		level	=> 2,
	);

Crosss-module usage

	use Text::Indent::Simple (
		eol	=> 1,
		size	=> 1,
		level	=> 2,
	);

=head1 DESCRIPTION

The module is designed to be used for printing indentation in the simplest way as much as possible. It provides methods for turning on/off indentation and output using the current indentation.

The module design was invented during discussion on the PerlMonks board at L<https://perlmonks.org/?node_id=1205367>. Monks there suggested to name the methods for increasing and decreasing indents in the POD-like style. Also they inspired to use overloading.

=head1 METHODS AND FEATURES

=head2 Constructor

The constructor is used for creating the indentaion object. If you need to use indentaion in one style across modules, initialize the indent object in the main program and instatiate it in other modules that use indentation.

To construct a new B<Text::Indent::Simple> object, invoke the B<new> method passing the following options as a hash:

=over 4

=item B<level>

The initial indentation level. Defaults to C<0> (meaning no indent).

=item B<size>

The number of indent spaces used for each level of indentation. If not specified, the B<$Text::Indent::Simple::DefaultSize> is used.

=item B<tab>

The flag to use C<TAB> as indent.

=item B<eol>

If specified, tell the B<item> method to add automatically new lines to the input arguments.

=item B<propagate>

Enable cross-module usage with B<$Text::Indent::Simple::indent> variable.

=back

The options B<tab> and B<size> have impact on the same stuff. If B<tab> is specified, it cancels B<size> and any other characters in favor of C<TAB>.

=head2 B<over>

Increase the indentation by one or more levels. Defaults to C<1>.

If the method is invoked in the scalar context, it enables to apply indentation locally for the particular lines (see the Examples 1 and 2).

=head2 B<back>

Decrease the indentation by one or more levels. Defaults to C<1>.

If the method is invoked in the scalar context, it enables to apply indentation locally for the particular lines (see the Examples 1 and 2).

=head2 reset

Reset all indentations to the initial level (as it has been set in the cunstructor).

=head2 item

This method returns all arguments indented. Accordingly the B<eol> option and the configured C<$\> variable it appends all but last arguments with new line.

=head2 Variables

=over 4

=item B<$Text::Indent::Simple::DefaultSpace>

The text to be used for indentation. Defaults to one C<SPACE> character.

=item B<$Text::Indent::Simple::DefaultSize>

The number of indent spaces used for each level of indentation. Defaults to C<4>.

=item B<$Text::Indent::Simple::indent>

The indentation object for using across modules.

=back

=head2 Overloading

The only stringify conversion is enabled. It allows to print indentation standalone as follows:

	print $indent, "some text\n";

=head1 EXAMPLES

=head2 Example 1. Simplest usage

Indent each line with 4 spaces, by default. Each line will be appended with new line. The last line will be indented with 10 spaces.

	use Text::Indent::Simple;
	my $indent = Text::Indent::Simple->new;

	$\ = "\n";

	# Indent each line with 4 spaces (by default)
	$indent->over;
	print $indent->item(
		"To be or not to be",
		"That is the question",
	);
	$indent->back;

	# Indent to 5th level the particular line (with 20 spaces)
	$indent->over(5);
	print $indent->item("William Shakespeare");

=head2 Example 2. Simple usage

Set indent to one C<SPACE> character. Start indentation is set to 2. Each indented string is appended with new line.

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

=head2 Example 3. Cross-module usage

Import module and initialize indentation accordingly the options. This indentation will be available across all modules.

	use Text::Indent::Simple (
		eol	=> 1,
		size	=> 1,
		level	=> 2,
	);

	# The indentation object is available across all modules
	my $indent = $Text::Indent::Simple::indent;

=head2 Example 4. Cross-module usage

The same as above but importing and initialization are separate.

	use Text::Indent::Simple;

	Text::Indent::Simple->new(
		propagate => 1, # Enable cross-module usage
		eol	=> 1,
		size	=> 1,
		level	=> 2,
	);

	# The indentation object is available across all modules
	my $indent = $Text::Indent::Simple::indent;

=head1 SEE ALSO

L<Text::Indent>

L<Print::Indented>

L<String::Indent>

... and lot of other competitors.

=head1 AUTHOR

Ildar Shaimordanov E<lt>ildar.shaimordanov@gmail.comE<gt>

=head1 COPYRIGHT

Copyright (c) 2017-2020 Ildar Shaimordanov. All rights reserved.

This program is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

See L<http://www.perl.com/perl/misc/Artistic.html>

=cut

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
