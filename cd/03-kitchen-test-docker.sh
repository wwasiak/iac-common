#!/bin/bash

#we assume the code is in . dir

#fix PATH for jenkins
export PATH=$PATH:~/bin/

echo Starting kitchen test \(docker\) - `date`
kitchen test
CODE=$?
echo Finishing kitchen test \(docker\) - `date`

exit $CODE
