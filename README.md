Some helpers for constructing jQuery UIs with Bacon.js. This is stuff that I've extracted from more specific codebases and that's too UI-specific to qualify for inclusion in Bacon.js.

### Bacon.UI.textFieldValue(textfield)

Returns the value of a textfield (jQuery object) as a Property. Currently bound to keyups, input, cut, paste.

    var username = Bacon.UI.textFieldValue($("#username"))

### Bacon.UI.optionValue(optionField, initValue)

Returns the value of an option field (jQuery object) as a Property.

Optionally, you can define `initValue`, which will set it as the initial value
of the underlying `<select>` HTML element.

#### Example usage:

Given HTML like this:

    <select id="doneness-level">
      <option value="raw">Raw doneness level</option>
      <option value="medium">Medium doneness level</option>
    </select>

You can do like this:

    var baconRoastingLevel = Bacon.UI.optionValue(
      $('#doneness-level'),
      'medium' // Set the select element initially to value "medium"
    )

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
    var usernameAvailable = username.changes().ajax()

Install
=======

You can download the latest [generated javascript](https://raw.github.com/raimohanska/Bacon.UI.js/master/Bacon.UI.js).

..or you can use script tags to include this file directly from Github:

```html
<script src="https://raw.github.com/raimohanska/Bacon.UI.js/master/Bacon.UI.js"></script>
```

If you're targeting to [node.js](http://nodejs.org/), you can

    npm install baconui

For [bower](https://github.com/twitter/bower) users:

    bower install bacon-ui
    
## Running tests

### On command-line interface

1. Install <http://phantomjs.org/>
2. `./run-tests.sh`

### On browser

1. Install <http://phantomjs.org/>
2. `python -m SimpleHTTPServer 9999`
3. go to <http://localhost:9999/test/runner.html>

### Running tests on Travis-ci.org

It can be done. Are you the one to do this?
