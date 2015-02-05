deepCopy = require 'clone'

export update = (o, fn) ->
  with deepCopy(o)
    fn ..

export class Lens
  ({@get, @set}) ->

  compose: (other) ~>
    new Lens
      get: ~> other.get(@get(it))
      set: (state, val) ~~> @set(state, other.set(@get(state), val))

export class LensDo
  (@state) ->
  do: (lens, val) ~~>
    @state |>= lens.set(_, val)
    this
  unwrap: -> @state

export do = -> new LensDo(it)

export id = new Lens
  get: -> it
  set: (, val) --> val

export merge = new Lens do
  get: -> it
  set: (state, newVal) --> update(state, (<<< newVal))

export push = new Lens do
  get: -> it
  set: (state, newVal) --> update(state, (.push(newVal)))

export at = (index) ->
  new Lens
    get: (.[index])
    set: (state, newVal) --> update(state, (.[index] = newVal))

