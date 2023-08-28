#!bin/bash

ansible-playbook -i inventory.ini provision_users.yml --private-key=private_key.pem
