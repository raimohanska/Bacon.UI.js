Some helpers for constructing jQuery UIs with Bacon.js. This is stuff that I've extracted from more specific codebases and that's too UI-specific to qualify for inclusion in Bacon.js.

### Bacon.UI.textFieldValue(textfield)

Returns the value of a textfield (jQuery object) as a Property. Currently bound to keyups, input, cut, paste.

    var username = Bacon.UI.textFieldValue($("#username"))

### Bacon.UI.optionValue(optionField)

Returns the value of an option field (jQuery object) as a Property.

### Bacon.UI.checkBoxGroupValue(checkBoxes, initValue)

Returns the value of a checkbox group (jQuery object representing multiple checkboxes) as a Property. The value will be an array containing the values of selected checkboxes. The optional `initValue` param can be used to set the initial state.

Now suppose you have three checkboxes for selecting the media for customer contacts:

    <input type="checkbox" value="email"/>
    <input type="checkbox" value="sms"/>
    <input type="checkbox" value="snailmail"/>

To set up a property containing selected media, with "sms" initially selected:

    var selectedMedia = Bacon.UI.checkBoxGroupValue($("input"), ["sms"])

### Bacon.EventStream.ajax(fn)

Performs an AJAX request on each event of your stream, collating results in the result stream. 

The source stream is expected to provide the parameters for the AJAX call.

    var usernameRequest = username.map(function(un) { return { type: "get", url: "/usernameavailable/" + un } })
    var usernameAvailable = username.changes().ajax(
    
### Bacon.Observable.pending(src)

Use this on your AJAX request stream, and use the response stream as the "response" parameter. You'll get a property that indicates whether an AJAX request is currently pending.

This is nice for displaying an "AJAX indicator" when a request is pending.

    var usernamePending = usernameAvailable.awaiting(usernameChange)
    usernamePending.assign($(".ajax-indicator"), "toggle")
    