Some helpers for constructing jQuery UIs with Bacon.js. This is stuff that I've extracted from more specific codebases and that's too UI-specific to qualify for inclusion in Bacon.js.

### Bacon.UI.textFieldValue(textfield)

Returns the value of a textfield (jQuery object) as a Property. Currently bound to keyups only.

    var username = Bacon.UI.textFieldValue($("#username"))

### Bacon.EventStream.ajax(fn)

Performs an AJAX request on each event of your stream, collating results in the result stream. The `fn` param should be a function that accepts a value from the source stream and returns parameters object for the AJAX call.

    var usernameAvailable = username.changes().ajax(function(username) { 
      return { type: "get", url: "/usernameavailable/" + username} 
    })
    
### Bacon.Observable.pending(src)

Use this on your AJAX response stream, and use the request stream as the "src" parameter. You'll get a property that indicates whether an AJAX request is currently pending.

This is nice for displaying an "AJAX indicator" when a request is pending.

    var usernamePending = usernameAvailable.pending(usernameChange)
    usernamePending.assign($(".ajax-indicator"), "toggle")