deepCopy = require 'clone'

update = (o, fn) ->
  newO = deepCopy(o)
  fn(newO)
  newO

class Lens
  constructor: ({@get, @set}) ->

  compose: (other) =>
    new Lens
      get: (state) => other.get(this.get(state))
      set: (state, val) => this.set(state, other.set(this.get(state), val))

class LensDo
  constructor: (@state) ->
  do: (lens, val) -> @state = lens.set(@state, val); this
  unwrap: () -> @state

module.exports =
  Lens: Lens

  do: (state) -> new LensDo(state)

  id: new Lens
    get: (state) -> state
    set: (state, val) -> val

  merge: new Lens
    get: (state) -> state
    set: (state, newVal) -> update(state, (newState) -> newState[x] = y for x, y of newVal)

  push: new Lens
    get: (state) -> state
    set: (state, newVal) -> update(state, (newState) -> newState.push(newVal))

  at: (index) -> new Lens
    get: (state) -> state[index]
    set: (state, newVal) -> update(state, (newState) -> newState[index] = newVal)

