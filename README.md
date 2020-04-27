# indent-pm

Lightweight indent handling across modules

Simple usage

```
	use Text::Indent::Simple;
	my $indent = Text::Indent::Simple->new(
		eol	=> 1,
		size	=> 1,
		level	=> 2,
	);
```

Cross-module usage

```
	use Text::Indent::Simple (
		eol	=> 1,
		size	=> 1,
		level	=> 2,
	);
```
