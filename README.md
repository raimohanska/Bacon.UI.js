Some helpers for constructing jQuery UIs with Bacon.js. This is stuff that I've extracted from more specific codebases and that's too UI-specific to qualify for inclusion in Bacon.js.

`Bacon.UI.textFieldValue(textfield)` returns the value of a textfield (jQuery object) as a Property. Currently bound to keyups only.

`Bacon.Observable.pending(src)` use this on your AJAX response stream, and use the request stream as the "src" parameter. You'll get a property that indicates whether an AJAX request is currently pending.

`Bacon.EventStream.ajax()`