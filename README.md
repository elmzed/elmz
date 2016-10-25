# elmz

## Motivation

This package hopes to follow the [original spirit][original spirit] of [scalaz][scalaz].
The original spirit was exploring three principles:

<dl>
  <dt>Parametricity</dt>
  <dd>Eliminate possible implementations of a function based on the type and get continuous unit tests for free.</dd>

  <dt>Equational Reasoning</dt>
  <dd>Construct larger programs from smaller ones, or destruct larger programs into smaller ones.</dd>

  <dt>Abstraction</dt>
  <dd>Avoid repetition of work.</dd>
</dl>

Why these three principles? Because we have work to do, today.
Maybe in the future we can be more productive in elm without these.
However, until that day comes, these three principles can make us more productive right now.

If you're unfamiliar with the terms, don't fret. You probably already use them regularly without knowing it. If you've ever written a function `Model -> Html msg` you're using parametricity. You're saying that the html being returned does not ever have any messages. If you've ever taken a large function and broken it into smaller functions and values, you're using equational reasoning. If you've ever seen two functions do the same thing but on different types and then made them both work through a single function, you're using abstraction.

[original spirit]: https://youtu.be/uZd-MvN1n4E?t=3m13s
[scalaz]: https://github.com/scalaz/scalaz
