#! /bin/bash

cd `dirname $0`

dig +short -x $(cd ../terraform/; terraform output ip) | sed 's/\.$//'
