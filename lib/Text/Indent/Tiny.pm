=head1 NAME

Text::Indent::Tiny - tiny and flexible indentation across modules

=head1 VERSION

This module version is 0.5.3.

=head1 SYNOPSIS

Simple usage

	use Text::Indent::Tiny;
	my $indent = Text::Indent::Tiny->new(
		eol	=> 1,
		size	=> 1,
		level	=> 2,
	);

Cross-module usage

	use Text::Indent::Tiny (
		eol	=> 1,
		size	=> 1,
		level	=> 2,
	);

=head1 DESCRIPTION

The module is designed to be used for printing indentation in the simplest way as much as possible. It provides methods for turning on/off indentation and output using the current indentation.

The module design was invented during discussion on the PerlMonks board at L<https://perlmonks.org/?node_id=1205367>. Monks there suggested to name the methods for increasing and decreasing indents in the POD-like style. Also they inspired to use overloading.

=head1 INSTANTIATING

=head2 Constructor B<new()>

The constructor is used for creating the indentaion object. If you need to use indentaion in one style across modules, initialize the indent object in the main program and instatiate it in other modules with the method B<instance()>.

To construct a new B<Text::Indent::Tiny> object, invoke the B<new> method passing the following options as a hash:

=over 4

=item B<level>

The initial indentation level. Defaults to C<0> (meaning no indent).

=item B<size>

The number of indent spaces used for each level of indentation. If not specified, the B<$Text::Indent::Tiny::DefaultSize> is used.

=item B<tab>

The flag to use C<TAB> as indent.

=item B<text>

The arbitrary text that is assumed to be indentation.

=item B<eol>

If specified, tell the B<item> method to add automatically new lines to the input arguments.

=back

The options B<text>, B<tab> and B<size> have impact on the same stuff. When specified, B<text> has the highest priority. If B<tab> is specified, it cancels B<size> and any other characters in favor of C<TAB>.

=head2 Singleton B<instance()>

This method returns the current object instance or create a new one by calling the constructor. In fact, it implements a singleton restricting the only instance across a program and its modules. It allows the same set of arguments as the constructor.

=head1 METHODS

The following methods are used for handling with indents: increasing, decreasing, resetting them and applying indents to strings.

There are two naming styles. The first one is a POD-like style risen from the discussion at PerlMonks https://perlmonks.org/?node_id=1205367. The second one is more usual.

Calling the methods in a void context is applied to the instance itself. If the methods are invoked in the scalar context, a new instance is created in this context and changes are applied for this instance only. See for details the Examples 1 and 2.

=head2 B<over()>, B<increase()>

Increase the indentation by one or more levels. Defaults to C<1>.

=head2 B<back()>, B<decrease()>

Decrease the indentation by one or more levels. Defaults to C<1>.

=head2 B<cut()>, B<reset()>

Reset all indentations to the initial level (as it has been set in the cunstructor).

=head2 B<item()>

This method returns all arguments indented. Accordingly the B<eol> option and the configured C<$\> variable it appends all but last arguments with new line.

=head1 VARIABLES

=over 4

=item B<$Text::Indent::Tiny::DefaultSpace>

The text to be used for indentation. Defaults to one C<SPACE> character.

=item B<$Text::Indent::Tiny::DefaultSize>

The number of indent spaces used for each level of indentation. Defaults to C<4>.

=back

=head1 OVERLOADING

The only stringify conversion is enabled. It allows to print indentation standalone as follows:

	print $indent, "some text\n";

or even

	print "${indent}some text\n";

=head1 EXAMPLES

=head2 Example 1. Simplest usage

Indent each line with 4 spaces, by default. Each line will be appended with new line. The last line will be indented with 10 spaces.

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

	# Indent the particular line locally to 5th level (with 20 spaces)
	print $indent->over(5)->item("William Shakespeare");

=head2 Example 2. Simple usage

Set indent to one C<SPACE> character. Start indentation is set to 2. Each indented string is appended with new line.

	use Text::Indent::Tiny;
	my $indent = Text::Indent::Tiny->new(
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
	$indent->cut;
	print $indent->item("| after reset");

=head2 Example 3. Cross-module usage

Import module and initialize indentation accordingly the options. This indentation will be available across all modules.

	# Instantiate by the program
	use Text::Indent::Tiny (
		eol	=> 1,
		size	=> 1,
		level	=> 2,
	);

	# The indentation object is available across all modules
	my $indent = Text::Indent::Tiny->instance();

=head2 Example 4. Cross-module usage

The same as above but importing and initialization are separate.

	use Text::Indent::Tiny;

	# The indentation object is available across all modules
	my $indent = Text::Indent::Tiny->instance(
		eol	=> 1,
		size	=> 1,
		level	=> 2,
	);

=head1 SEE ALSO

L<Text::Indent>

L<Print::Indented>

L<String::Indent>

L<Indent::Block>

L<Indent::String>

... and lot of other competitors.

=head1 AUTHOR

Ildar Shaimordanov E<lt>ildar.shaimordanov@gmail.comE<gt>

=head1 COPYRIGHT

Copyright (c) 2017-2020 Ildar Shaimordanov. All rights reserved.

This program is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

See L<http://www.perl.com/perl/misc/Artistic.html>

=cut

package Text::Indent::Tiny;

use 5.004;

use strict;
use warnings;

our $VERSION = "0.5.3";

our $DefaultSpace = " ";
our $DefaultSize = 4;

# The indent that is supposed to be used across a program and modules.

my $indent;

# Aliases for using in more familiar kind

*reset    = \&cut;
*increase = \&over;
*decrease = \&back;

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

	$p{text} //= $p{tab} ? "\t" : $t x lclamp(1, $p{size} // $s);
	$p{level} = lclamp(0, $p{level} // 0);

	my $self = bless {
		text	=> $p{text},
		eol	=> $p{eol},
		level	=> $p{level},
		initial	=> $p{level},
	}, $class;

	$self->set_indent;

	return $self;
}

# =========================================================================

sub instance {
	$indent //= new(@_);
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

sub cut {
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
