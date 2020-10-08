# indent-pm

Lightweight indent handling across modules

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
```
