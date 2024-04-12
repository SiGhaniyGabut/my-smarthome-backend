# Contribution Notes

## Guidelines
Please ensure your pull request adheres to the following guidelines:
  - Search previous suggestions before making a new one, as yours may be a duplicate.
  - Make an individual pull request for each suggestion.
  - Use the following format: `[Name](link) - Description.`
  - New categories, or improvements to the existing categorization are welcome.
  - Keep descriptions short and simple, but descriptive.
  - End all descriptions with a full stop/period.
  - Check your spelling.
  - Make sure your text editor is set to remove trailing whitespace.
  - The pull request should have a useful title and include a link to the package and why it should be included.

## Quality standard
To stay on the list, projects should follow these quality standards:
  - Generally useful to the community.
  - Actively maintained (even if that just means acknowledging open issues when they arise).
  - Stable.
  - Documented.
  - Tests (even simple as Blackbox), but attention to edge cases.
  - Code quality.

## Conventions
### Writing code
- Use 2 spaces for indentation.
- Use descriptive names for variables, functions, classes, etc.
- Use `?` suffix for methods that return booleans.
- Use `!` suffix for methods that modify the object.
- Add spaces inside curly brackets if that is a one-line block, otherwise (like Hashes or NamedTuple) don't.
- Add new line after guard clauses.
- Try to ignore parentheses on method calls **when possible**, this will make the code cleaner and more human-like.
- Try to use Guard Clauses instead of Nested Conditionals.
- For methods call chains that each method call requires paramaters, add a new line for each method call.
- For methods call that requires a Hash/NamedTuple as a parameter, add a new line for each key-value pair, and encapsulate it with parentheses.
- For methods that return a boolean, it's default return value should be `false`. Use guard clauses to return `true` when the condition is met.
- Avoid using `set_`, `get_`, `is_` prefixes for methods.
- Avoid using `self` when it's not necessary.
- Avoid using non-descriptive names (even for iterators) like: `switches.select { |s| s.active }`, unless the iteration data is not very important.