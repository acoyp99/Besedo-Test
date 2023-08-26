#!bin/bash

ansible-playbook -i inventory.ini provision_users.yml --private-key=path_to_your_private_key.pem
