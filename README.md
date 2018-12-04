This repo contains examples from Chapter 1 of Refactoring (2nd edition),
converted to Ruby.

You can view the commits individually to see each change. Some commits
have an corresponding explanation for Ruby-specific implementation details.

A few small changes were needed:

Since the `Intl.NumberFormat` isn't available, I replaced it with a simplified
equivalent.

In Ruby it's not possible directly assign a method to a variable, so I used a
lambda instead.

To prevent a name clash for `result`, I made use of a block-local variable,
`lambda do |perf, play; result|`.

I renamed the variables to use `snake_case` rather than `camelCase`.

# Testing

I added a simple integration test (using RSpec). If this was real code, I would
want more tests in place before I started to refactor.

# Style

I'm generally aiming to follow Ruby Community Style, and I'm using RuboCop to
validate it. I disabled some rules which don't make sense considering this is an
exercise rather than real code.

The book uses nested functions, which aren't available in Ruby, but can be
approximated using lambdas.

