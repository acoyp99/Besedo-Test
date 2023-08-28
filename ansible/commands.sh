#!bin/bash

ansible-playbook -i inventory.ini provision_users.yml --private-key=private_key.pem
ansible-vault encrypt_string '1dd249r32DD' --name 'passwd'
ansible-playbook site.yml --ask-vault-pass
