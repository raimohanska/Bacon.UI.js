(function() {
  Bacon.UI = {}
  Bacon.UI.textFieldValue = function(textfield) {
    function getValue() { return textfield.val() }
    return $(textfield).asEventStream("keyup").map(getValue).toProperty(getValue())
  }
  Bacon.UI.optionValue = function(option) {
    function getValue() { return option.val() }
    return option.asEventStream("change").map(getValue).toProperty(getValue())
  }
  Bacon.UI.checkBoxGroupValue = function(checkboxes) {
    function selectedValues() {
      return checkboxes.filter(":checked").map(function(i, elem) { return $(elem).val()})
    }
    return checkboxes.asEventStream("click").map(selectedValues).toProperty(selectedValues())
  }
  Bacon.Observable.prototype.pending = function(src) {
    return src.map(true).merge(this.map(false)).toProperty(false)
  }
  Bacon.EventStream.prototype.ajax = function() {
    return this.switch(function(params) { return Bacon.fromPromise($.ajax(params)) })
  }
})();
