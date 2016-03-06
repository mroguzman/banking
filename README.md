# Banking

Welcome to my Banking gem!

## Setup

Before execute any of the code inside this repo, please do run `bin/setup` to install dependencies.

This gem has been tested with Ruby version `2.3.0` so please use this version to execute this code.

## How to run tests

```sh
bundle exec rspec
```

## How to run part_2 exercise

```sh
bundle exec bin/part_2
```

## Questions

### How would you improve your solution?

- I think that my solution could be improved including a way to reference the bank from the account.
- Another good improvement would be to allow that class `Banking::TransferAgent` can execute different transfers (without the need to create different instances).

### How would you adapt your solution if transfers are not instantaneous?

I think into some solution with callbacks.

----

Author: Rocío Guzmán Pérez
