# indent-pm

Lightweight, tiny and flexible indent handling across a program and its modules. And there is no non-core modules' dependency.

Simple usage

```
	use Text::Indent::Tiny;
	my $indent = Text::Indent::Tiny->new(
		eol	=> 1,
		size	=> 1,
		level	=> 2,
	);
```

Cross-module usage

```
	use Text::Indent::Tiny (
		eol	=> 1,
		size	=> 1,
		level	=> 2,
	);

	$indent = Text::Indent::Tiny->instance;
```
