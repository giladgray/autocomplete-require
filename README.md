# Autocomplete Require [![Build Status](https://travis-ci.org/giladgray/autocomplete-require.svg?branch=master)] (https://travis-ci.org/giladgray/autocomplete-require)

An Autocomplete+ provider for basic Node require'd packages.

Handily supports built-in Node packages and attempts to load globally-installed or project-local packages (but doesn't always work).

Suggests completions based on contents of package export, including turning functions into snippets with arguments.

![screenshot](require-screenshot.png)

## Usage

```coffee
# first, require a package and assign it to a variable.
util = require 'util'

# then use the variable to see all suggestions.
# note the trailing . is important to indicate you're
# accessing property of the variable.
util.<whoa suggestions>

# start typing a property name to filter.
util.isF<filtered suggestions>

# advanced: give the package a different name!
qs = require 'querystring'
qs.<nifty!>
```
