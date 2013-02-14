var page = require('webpage').create()
var mochaTestsUrl = 'http://localhost:6789/test/runner.html'
page.open(mochaTestsUrl, function (status) {
  console.log('Running Mocha tests...')
  waitForMocha(function() {
    var passedTestsCount = page.evaluate(function() {
      return $('.test.pass').length
    })
    var failedTestsCount = page.evaluate(function() {
      return $('.test.fail').length
    })
    console.log('Tests passed: ' + passedTestsCount)
    console.log('Tests failed: ' + failedTestsCount)
    phantom.exit(failedTestsCount)
  })
});

function waitForMocha(onMochaComplete) {
  waitFor(function() {
    console.log('Waiting for Mocha tests to finish...')
    return page.evaluate(function() {
      return $("#mochaTestsCompleted").is(":visible")
    });
  }, function() {
    console.log("Mocha tests completed")
    onMochaComplete()
  })
}

function waitFor(testFx, onReady, timeOutMillis) {
  var maxtimeOutMillis = timeOutMillis ? timeOutMillis : 45000,
  start = new Date().getTime(),
  condition = false,
  interval = setInterval(function() {
    if ( (new Date().getTime() - start < maxtimeOutMillis) && !condition ) {
      condition = (typeof(testFx) === "string" ? eval(testFx) : testFx())
    } else {
      if(!condition) {
        console.log("'waitFor()' timeout");
        phantom.exit(1);
      } else {
        // console.log("'waitFor()' finished in " + (new Date().getTime() - start) + "ms.");
        typeof(onReady) === "string" ? eval(onReady) : onReady()
        clearInterval(interval)
      }
    }
  }, 500); //< repeat check every 50ms
};
