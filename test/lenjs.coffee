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
      lens = Ltest.a.compose(Ltest.b).compose(Ltest.c)

      it 'should return an object', ->
        lens.get(test).should.eql('Hello, World')

      it 'should set an object', ->
        newTest = lens.set(test, 'Bonjour le Monde !')

        newTest.a.b.c.should.eql 'Bonjour le Monde !'

  describe '.push', ->
    describe '-> a -> b -> d', ->
      lens = Ltest.a.compose(Ltest.b).compose(Ltest.d)

      it 'should return the array', ->
        lens.get(test).should.eql ['hello', 'bonjour']

      it 'should push a string to the array', ->
        newTest = lens.compose(lenses.push).set(test, "hola")

        lens.get(newTest).should.eql(['hello', 'bonjour', 'hola'])

  describe '.merge', ->
    describe '-> a', ->
      it 'should return the object', ->
        newTest = lenses.merge.get(test)
        newTest.should.eql test

      it 'should merge objects', ->
        newTest = lenses.merge.set(test, {foo: "bar"})

        newTest.foo.should.eql("bar")

  describe '.id', ->
    describe '-> a', ->
      it 'should return the initial object', ->
        lenses.id.get(test).should.eql test

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

