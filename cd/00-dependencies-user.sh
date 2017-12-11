#!/bin/bash

#fix PATH for jenkins
export PATH=$PATH:~/bin/

gem install bundler

CODE=$?
if [ "$CODE" -ne 0 ]; then
echo gem bundler installation failed
exit $?
fi

bundle install

exit $?