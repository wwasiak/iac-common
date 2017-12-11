#!/bin/bash

#we fail at the end
#don't use spaces in filenames
#we assume the code is in . dir

ERRORS_FOUND=0

array=($(find ./ -maxdepth 1 -regex '.*\.ya?ml'  -and -not -name '.kitchen.yml'))

for i in ${array[@]}; do
  ansible-playbook --syntax-check --list-tasks -i cd/hosts "$i"
  CODE=$?
  if [ "$CODE" -ne 0 ]; then
    ERRORS_FOUND=1
    echo Ansible playbook contains errors!
  fi
done


array=($(find ./test -maxdepth 5 -regex '.*\.ya?ml'))

for i in ${array[@]}; do
  ansible-playbook --syntax-check --list-tasks -i cd/hosts "$i"
  CODE=$?
  if [ "$CODE" -ne 0 ]; then
    ERRORS_FOUND=1
    echo Ansible playbook contains errors!
  fi
done


if [ "$ERRORS_FOUND" -ne 0 ]; then
  echo At least one of Ansible playbooks contain errors!
  exit 1
fi
