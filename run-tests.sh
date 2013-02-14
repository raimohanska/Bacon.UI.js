#!/bin/bash

phantom_bin=${1:-phantomjs}
python -m SimpleHTTPServer 6789 > /dev/null & test_pid=$!
$phantom_bin test/phantomjs-runner.js
phantom_exit_status=$?
kill $test_pid
exit $phantom_exit_status
