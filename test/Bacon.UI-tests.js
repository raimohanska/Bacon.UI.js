var expect = chai.expect

describe('#optionValue', function() {
  context('with initVal', function() {
    beforeEach(function(done) {
      $('#bacon-dom').html(
        '<select> <option value="first">1</option><option value="second">2</option> </select>'
      )
      done()
    })

    it('sets the initVal as the initial value of the underlying property',
      function() {
      var optionProperty = Bacon.UI.optionValue($('#bacon-dom'), 'second')
      optionProperty.onValue(function(optionValue) {
        expect(optionValue).to.equal('second')
      })
    })
  })
})

describe('signaling that tests are done', function() {
  it('puts a marker into dom so that the test runner knows we are done', 
    function() {
      $('body').append('<span id="mochaTestsCompleted">All tests run</span>')
    })
})
