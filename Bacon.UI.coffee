nonEmpty = (x) -> x and x.length > 0
isChrome = navigator.userAgent.toLowerCase().indexOf("chrome") > -1
Bacon.UI = {}

Bacon.UI.textFieldValue = (textfield, initValue) ->
  getValue = -> textfield.val()
  autofillPoller = ->
    if textfield.attr("type") is "password"
      Bacon.interval 100
    else if isChrome
      Bacon.interval(100).take(20).map(getValue).filter(nonEmpty).take 1
    else
      Bacon.never()
  textfield.val initValue if initValue isnt null
  textfield.asEventStream("keyup input")
  .merge(textfield.asEventStream("cut paste").delay(1))
  .merge(autofillPoller())
  .map(getValue).toProperty(getValue()).skipDuplicates()

Bacon.UI.optionValue = (option) ->
  getValue = -> option.val()
  option.asEventStream("change").map(getValue).toProperty getValue()

Bacon.UI.checkBoxGroupValue = (checkboxes, initValue) ->
  selectedValues = ->
    checkboxes.filter(":checked").map((i, elem) ->
      $(elem).val()
    ).toArray()
  
  if initValue
    checkboxes.each (i, elem) ->
      $(elem).attr "checked", initValue.indexOf($(elem).val()) >= 0

  checkboxes.asEventStream("click").map(selectedValues).toProperty selectedValues()

Bacon.UI.ajax = (params) -> Bacon.fromPromise $.ajax(params)

Bacon.UI.ajaxGet = (url, data, dataType) -> Bacon.UI.ajax({url, dataType, data})       

Bacon.UI.ajaxGetJSON = (url, data) -> Bacon.UI.ajax({url, dataType:"json", data})         

Bacon.UI.ajaxPost = (url, data, dataType) -> Bacon.UI.ajax({url, dataType, data, type:"POST"})

Bacon.Observable::awaiting = (response) ->
  @map(true).merge(response.map(false)).toProperty(false).skipDuplicates()

Bacon.EventStream::ajax = -> @flatMapLatest Bacon.UI.ajax

Bacon.UI.radioGroupValue = (radioButtons, init) ->
  if init?
    radioButtons.each (i, elem) ->
      $(elem).attr "checked", true if elem.value is init
  else init = radioButtons.filter(":checked").first().val()

  radioButtons.asEventStream("change").map((e) -> e.target.value).toProperty init

Bacon.UI.checkBoxValue = (checkbox, initValue) ->
  isChecked = -> !!checkbox.attr("checked")
  checkbox.attr "checked", initValue if initValue isnt null
  checkbox.asEventStream("change").map(isChecked).toProperty(isChecked()).skipDuplicates()

Bacon.UI.hash = (defaultValue) ->
  getHash = ->
    (if !!document.location.hash then document.location.hash else defaultValue)
  defaultValue = "" if defaultValue is undefined
  $(window).asEventStream("hashchange").map(getHash).toProperty(getHash()).skipDuplicates()