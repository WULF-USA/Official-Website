#!/bin/bash
set -e
if [ "${TEST_TYPE}" = "integration" ]; then
	bundle exec codeclimate-test-reporter
fi