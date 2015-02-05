lenses = require '../lib/lenjs'

test =
  a:
    b:
      c: "Hello, World"
      d: ["hello", "bonjour"]

Ltest = {}
Ltest[x] = lenses.at(x) for x in ["a", "b", "c", "d", "e", "f", "g", "h"]

describe 'lenses', ->
  describe '.at', ->
    describe '-> a -> b -> c', ->
      it 'should return an object', ->
        lens = Ltest.a.compose(Ltest.b).compose(Ltest.c)

        lens.get(test).should.eql('Hello, World')

  describe '.push', ->
    describe '-> a -> b -> d', ->
      it 'should push a string to the array', ->
        lens = Ltest.a.compose(Ltest.b).compose(Ltest.d)
        newTest = lens.compose(lenses.push).set(test, "hola")

        lens.get(newTest).should.eql(['hello', 'bonjour', 'hola'])

  describe '.merge', ->
    describe '-> a', ->
      it 'should merge objects', ->
        newTest = lenses.merge.set(test, {foo: "bar"})

        newTest.foo.should.eql("bar")

  describe '.id', ->
    describe '-> a', ->
      it 'should totally wipe out initial object', ->
        newTest = lenses.id.set(test, 42)

        newTest.should.eql 42

  describe '.do', ->
    it 'should update object accordingly', ->
      Lab = Ltest.a.compose(Ltest.b)
      Labd = Lab.compose(Ltest.d)
      newTest = lenses.do(test)
                  .do Lab.compose(lenses.at "e"), 42
                  .do Labd.compose(lenses.push), "hola"
                  .unwrap()

      newTest.a.b.d.should.eql ["hello", "bonjour", "hola"]
      newTest.a.b.e.should.eql 42

