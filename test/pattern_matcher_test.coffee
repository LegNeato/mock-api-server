'use strict'

assert = require 'assert'
patternMatcher = require '../src/pattern_matcher'

describe 'pattern matcher', ->

  it 'matches identical strings', ->
    matcher = patternMatcher 'hello, world'
    assert matcher 'hello, world'

  it 'says different strings without wildcards do not match', ->
    matcher = patternMatcher 'hello, world'
    assert !matcher 'goodbye, world'

  it 'handles wildcards in the middle of the pattern', ->
    matcher = patternMatcher 'hello*world'
    assert matcher 'hello, -- world'

  it 'handles wildcards at the beginning of the pattern', ->
    matcher = patternMatcher '*world'
    assert matcher 'hello, -- world'

  it 'handles wildcards at the end of the pattern', ->
    matcher = patternMatcher 'hello*'
    assert matcher 'hello, -- world'
