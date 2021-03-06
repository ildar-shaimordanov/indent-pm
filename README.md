# NAME

Text::Indent::Tiny - tiny and flexible indentation across modules

# VERSION

This module version is 0.1.2.

# SYNOPSIS

Simple usage:

``` 
        use Text::Indent::Tiny;

        my $indent = Text::Indent::Tiny->new(
                eol     => 1,
                size    => 1,
                level   => 2,
        );
```

Cross-module usage:

``` 
        use Text::Indent::Tiny (
                eol     => 1,
                size    => 1,
                level   => 2,
        );

        my $indent = Text::Indent::Tiny->instance;
```

Another and more realistic way of the cross-module usage:

``` 
        use Text::Indent::Tiny;

        my $indent = Text::Indent::Tiny->instance(
                eol     => 1,
                size    => 1,
                level   => 2,
        );
```

# DESCRIPTION

The module is designed to be used for printing indentation in the
simplest way as much as possible. It provides methods for turning on/off
indentation and output using the current indentation.

The module design was invented during discussion on the PerlMonks board
at <https://perlmonks.org/?node_id=1205367>. Monks suggested to name the
methods for increasing and decreasing indents in the POD-like style.
Also they inspired to `use overload`.

# INSTANTIATING

## Constructor **new()**

The constructor is used for creating the indentaion object. If you need
to use indentaion in one style across modules, initialize the indent
object in the main program and instatiate it in other modules with the
method **instance()**.

To construct a new **Text::Indent::Tiny** object, invoke the **new**
method passing the following options as a hash:

  - **level**  
    The initial indentation level. Defaults to `0` (meaning no indent).
    The specified initial level means the left edge which cannot be
    crossed at all. So any any indents will be estimated from this
    level.

  - **size**  
    The number of indent spaces used for each level of indentation. If
    not specified, the **$Text::Indent::Tiny::DefaultSize** is used.

  - **tab**  
    The flag to use `TAB` as indent.

  - **text**  
    The arbitrary text that is assumed to be indentation.

  - **eol**  
    If specified, tell the **item** method to add automatically new
    lines to the input arguments.

The options **text**, **tab** and **size** have impact on the same
stuff. When specified, **text** has the highest priority. If **tab** is
specified, it cancels **size** and any other characters in favor of
`TAB`.

## Singleton **instance()**

This method returns the current object instance or create a new one by
calling the constructor. In fact, it implements a singleton restricting
the only instance across a program and its modules. It allows the same
set of arguments as the constructor.

# METHODS

The following methods are used for handling with indents: increasing,
decreasing, resetting them and applying indents to strings.

There are two naming styles. The first one is a POD-like style, the
second one is more usual.

Calling the methods in a void context is applied to the instance itself.
If the methods are invoked in the scalar context, a new instance is
created in this context and changes are applied for this instance only.
See for details the Examples 1 and 2.

## **over()**, **increase()**

Increase the indentation by one or more levels. Defaults to `1`.

## **back()**, **decrease()**

Decrease the indentation by one or more levels. Defaults to `1`.

## **cut()**, **reset()**

Reset all indentations to the initial level (as it has been set in the
cunstructor).

## **item()**

This method returns all arguments indented. Accordingly the **eol**
option and the configured `$\` variable it appends all but last
arguments with new line.

## Example

``` 
        use Text::Indent::Tiny;
        my $indent = Text::Indent::Tiny->new;

        # Let's use newline per each item
        $\ = "\n";

        # No indent
        print $indent->item("Poem begins");

        # Indent each line with 4 spaces (by default)
        $indent->over;
        print $indent->item(
                "To be or not to be",
                "That is the question",
        );
        $indent->back;

        # Indent the particular line locally to 5th level (with 20 spaces)
        print $indent->over(5)->item("William Shakespeare");

        # No indent
        print $indent->item("Poem ends");
```

# VARIABLES

  - **$Text::Indent::Tiny::DefaultSpace**  
    The text to be used for indentation. Defaults to one `SPACE`
    character.

  - **$Text::Indent::Tiny::DefaultSize**  
    The number of indent spaces used for each level of indentation.
    Defaults to `4`.

# OVERLOADING

Some one could find more convenient using the indents as objects of
arithmetic operations and/or concatenated strings.

The module overloads the following operations:

  - `""`  
    Stringify the indentation.

  - `+`  
    Increase the indentation.

  - `-`  
    Decrease the indentation.

  - `.`  
    The same as `$indent->item()`.

## Example

So using the overloading the above example can looks more expressive:

``` 
        use Text::Indent::Tiny;
        my $indent = Text::Indent::Tiny->new;

        # Let's use newline per each item
        $\ = "\n";

        # No indent
        print $indent . "Poem begins";

        # Indent each line with 4 spaces (by default)
        print $indent + 1 . [
                "To be or not to be",
                "That is the question",
        ];

        # Indent the particular line locally to 5th level (with 20 spaces)
        print $indent + 5 . "William Shakespeare";

        # No indent
        print $indent . "Poem ends";
```

# SEE ALSO

[Text::Indent](https://metacpan.org/pod/Text::Indent)

[Print::Indented](https://metacpan.org/pod/Print::Indented)

[String::Indent](https://metacpan.org/pod/String::Indent)

[Indent::Block](https://metacpan.org/pod/Indent::Block)

[Indent::String](https://metacpan.org/pod/Indent::String)

# ACKNOWLEDGEMENTS

Thanks to PerlMonks community for suggesting good ideas.

<https://perlmonks.org/?node_id=1205367>

# AUTHOR

Ildar Shaimordanov, `<ildar.shaimordanov at gmail.com>`

# LICENSE AND COPYRIGHT

This software is Copyright (c) 2020 by Ildar Shaimordanov.

This program is released under the following license:

``` 
  MIT License

  Copyright (c) 2017-2020 Ildar Shaimordanov

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  SOFTWARE.
```
