This repo contains examples from Refactoring (2nd edition) converted to Ruby.

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

I'm aiming to follow Ruby Community Style, and I'm using RuboCop to validate
it. I disabled some rules which don't make sense considering this is an exercise
rather than real code.
