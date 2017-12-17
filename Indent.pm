=head1 NAME

indent - simple indentation

=head1 SYNOPSIS

    # Print with indentation of 4 spaces and automatical line ending.
    use Indent indent_size => 4, indent_eol => 1;
    Indent::over;
    Indent::printf "Hello, world!";
    Indent::back;

=head1 DESCRIPTION

The module is designed to be used in simplest way as much as possible. It 
provides static methods to configure, turn on, turn off indentation and 
output using the current indentation.

=head2 Indent::over

Increase the indentation.

=head2 Indent::back

Decrease the indentation.

=head2 Indent::reset

Reset all indentations.

=head2 Indent::print

=head2 Indent::vprint

=head2 Indent::printf

Display arguments using the current settings for indentation and line 
ending. These methods work almost similar to their core analogs except 
they are not designed to work with file handlers. Another difference is 
that B<Indent::printf> is able to print using the line ending setting 
implicitly. B<Indent::vprint> applies indentation to each input argument.

=head2 Indent::current

Return the current indentaion string.

=head2 Indent::config

Configure the indentation. Parameters are passed as a hash.

=over 4

=item B<indent_size>

The indentation size, the number of SPACE characters used in one 
indentation step.

=item B<indent_tab>

The flag to use TAB instead SPACE. This option cancels the B<indent_size> 
option.

=item B<indent_eol>

Output record separator for printing. It works similar to B<$\>. By 
default it is not defined.

=back

=head1 SEE ALSO

L<Text::Indent>

L<String::Indent>

... and lot of other competitors.

=head1 AUTHOR

Ildar Shaimordanov E<lt>ildar.shaimordanov@gmail.comE<gt>

=head1 COPYRIGHT

Copyright (c) 2017 Ildar Shaimordanov. All rights reserved. 

This program is free software; you can redistribute it and/or modify it 
under the same terms as Perl itself.

See L<http://www.perl.com/perl/misc/Artistic.html>

=cut

package Indent;

use strict;
use warnings;

our $INDENT = " " x 4;
our $EOL = $\;

sub import {
	shift;
	goto &config;
}

# =========================================================================

sub config {
	my %opts = @_;

	if ( $opts{indent_tab} ) {
		$INDENT = "\t";
	} elsif ( 
		defined $opts{indent_size} 
		&& $opts{indent_size} =~ /^\d+$/ 
	) {
		$INDENT = " " x $opts{indent_size};
	}

	if ( defined $opts{indent_eol} ) {
		$EOL = $opts{indent_eol} ? "\n" : $\;
	}
}

my @indent = ( "" );

sub reset {
	@indent = $indent[0];
}

sub current {
	$indent[-1];
}

sub over {
	push @indent, current . $INDENT;
}

sub back {
	pop @indent if @indent > 1;
}

sub print {
	local $\ = $EOL;
	CORE::print current, @_;
}

sub vprint {
	local $\ = $EOL;
	CORE::print current, $_ for ( @_ );
}

sub printf {
	Indent::print sprintf(( shift || "" ), @_);
}

1;

# =========================================================================

# EOF
