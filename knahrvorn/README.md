# Run the playbook
ansible-playbook playbook.yml -i inventory --vault-password-file=../.vault-pw
ansible-playbook playbook.yml -i inventory --tags common,network --vault-password-file=../.vault-pw
