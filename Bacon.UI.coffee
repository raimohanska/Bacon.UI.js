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

Bacon.UI.optionValue = (option, initVal) ->
  if initVal?
    option.val(initVal)
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

Bacon.UI.ajax = (params, abort) -> Bacon.fromPromise $.ajax(params), abort

Bacon.UI.ajaxGet = (url, data, dataType, abort) -> Bacon.UI.ajax({url, dataType, data}, abort)       

Bacon.UI.ajaxGetJSON = (url, data, abort) -> Bacon.UI.ajax({url, dataType: "json", data}, abort)         

Bacon.UI.ajaxPost = (url, data, dataType, abort) -> Bacon.UI.ajax({url, dataType, data, type: "POST"}, abort)

Bacon.UI.ajaxGetScript = (url, abort) -> Bacon.UI.ajax({url, dataType: "script"}, abort)

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
  defaultValue = "" if defaultValue is `undefined`
  $(window).asEventStream("hashchange").map(getHash).toProperty(getHash()).skipDuplicates()

# jQuery DOM Events
$.fn.extend
  keydownE: (args...) -> @asEventStream "keydown", args...
  keyupE: (args...) -> @asEventStream "keyup", args...
  keypressE: (args...) -> @asEventStream "keypress", args...

  clickE: (args...) -> @asEventStream "click", args... 
  dblclickE: (args...) -> @asEventStream "dblclick", args... 
  mousedownE: (args...) -> @asEventStream "mousedown", args... 
  mouseupE: (args...) -> @asEventStream "mouseup", args...

  mouseenterE: (args...) -> @asEventStream "mouseenter", args...
  mouseleaveE: (args...) -> @asEventStream "mouseleave", args...
  mousemoveE: (args...) -> @asEventStream "mousemove", args...
  mouseoutE: (args...) -> @asEventStream "mouseout", args...
  mouseoverE: (args...) -> @asEventStream "mouseover", args...

  resizeE: (args...) -> @asEventStream "resize", args...
  scrollE: (args...) -> @asEventStream "scroll", args...
  selectE: (args...) -> @asEventStream "select", args...
  changeE: (args...) -> @asEventStream "change", args...

  submitE: (args...) -> @asEventStream "submit", args...
  
  blurE: (args...) -> @asEventStream "blur", args...
  focusE: (args...) -> @asEventStream "focus", args...
  focusinE: (args...) -> @asEventStream "focusin", args...
  focusoutE: (args...) -> @asEventStream "focusout", args...

  loadE: (args...) -> @asEventStream "load", args...
  unloadE: (args...) -> @asEventStream "unload", args...

# jQuery Effects
$.fn.extend
  animateE: (args...) -> Bacon.fromPromise @animate(args...).promise()
  showE: (args...) -> Bacon.fromPromise @show(args...).promise()
  hideE: (args...)-> Bacon.fromPromise @hide(args...).promise()
  toggleE: (args...) -> Bacon.fromPromise @toggle(args...).promise()

  fadeInE: (args...) -> Bacon.fromPromise @fadeIn(args...).promise()
  fadeOutE: (args...) -> Bacon.fromPromise @fadeOut(args...).promise()
  fadeToE: (args...) -> Bacon.fromPromise @fadeTo(args...).promise()
  fadeToggleE: (args...) -> Bacon.fromPromise @fadeToggle(args...).promise()

  slideDownE: (args...) -> Bacon.fromPromise @slideDown(args...).promise()
  slideUpE: (args...) -> Bacon.fromPromise @slideUp(args...).promise()
  slideToggleE: (args...) -> Bacon.fromPromise @slideToggle(args...).promise()