#!/bin/bash

# Script to create and configure a GCP Compute Instance using Ansible.

# Usage: ./create_gcp_instance.sh [--protect=true|false] [--credentials=/path/to/service-account.json] [--ssh_key_path=/path/to/ssh-key.pem]

# Default values
protect="false"
credentials=""
ssh_key_path=""

# Parse CLI arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --protect=*) protect="${1#*=}" ;;
        --credentials=*) credentials="${1#*=}" ;;
        --ssh_key_path=*) ssh_key_path="${1#*=}" ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

echo "Deletion protection is set to: $protect"
if [[ -n "$credentials" ]]; then
    echo "Using credentials file: $credentials"
fi
if [[ -n "$ssh_key_path" ]]; then
    echo "Using SSH key path: $ssh_key_path"
fi

# Build the extra-vars string only if any arguments are passed
extra_vars=""
if [[ -n "$protect" || -n "$credentials" || -n "$ssh_key_path" ]]; then
    if [[ -n "$protect" ]]; then
        extra_vars="deletion_protection=$protect"
    fi
    if [[ -n "$credentials" ]]; then
        extra_vars="$extra_vars service_account_file=$credentials"
    fi
    if [[ -n "$ssh_key_path" ]]; then
        extra_vars="$extra_vars ssh_key_path=$ssh_key_path"
    fi
fi

# Run the Ansible playbook
if [[ -n "$extra_vars" ]]; then
    echo "Running Ansible playbook with extra-vars: $extra_vars"
    ansible-playbook playbooks/create_compute_instance.yml --extra-vars "$extra_vars"
else
    echo "Running Ansible playbook without extra-vars"
    ansible-playbook playbooks/create_compute_instance.yml
fi

exit $?
