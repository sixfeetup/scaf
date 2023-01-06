## What is pre-commit
pre-commit is a hook which is useful for identifying simple issues before
submission to code review. We run our hooks on every commit to automatically
point out issues in code such as missing semicolons, trailing whitespace,
and debug statements.
By pointing these issues out before code review, this allows a code reviewer
to focus on the architecture of a change while not wasting time with trivial
style nitpicks.

## Installation using pip:

`$ pip install pre-commit`

## Install the git hook scripts

`$ pre-commit install`

*now pre-commit will run automatically on git commit*

## Update pre-commit

`pre-commit autoupdate`
