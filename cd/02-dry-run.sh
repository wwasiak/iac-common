#!/bin/bash

#we assume the code is in . dir

echo Starting dry run - `date`

ansible-playbook -C -i cd/hosts -c local iac-common.yaml

CODE=$?

if [ "$CODE" -ne 0 ]; then
  echo Finishing dry run WITH ERRORS - `date`
  exit $CODE
fi

ansible-playbook -C -i cd/hosts -c local docker-setup.yaml

CODE=$?

if [ "$CODE" -ne 0 ]; then
  echo Finishing dry run WITH ERRORS - `date`
  exit $CODE
fi

echo Finishing dry run - `date`

exit $CODE
