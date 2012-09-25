(function() {
  Bacon.UI = {}
  Bacon.UI.textFieldValue = function(textfield) {
    function getValue() { return textfield.val() }
    return $(textfield).asEventStream("keyup").map(getValue).toProperty(getValue())
  }
  Bacon.Observable.prototype.pending = function(src) {
    return src.map(true).merge(this.map(false)).toProperty(false)
  }
  Bacon.EventStream.prototype.ajax = function(valueToAjaxParams) {
    return this.switch(function(value) { return Bacon.fromPromise($.ajax(valueToAjaxParams(value))) })
  }
})();