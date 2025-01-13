#!/bin/bash

# Script to destroy a GCP Compute Instance using Ansible.

# Usage: ./destroy_gcp_instance.sh [--credentials=/path/to/service-account.json]

# Default value
credentials=""

# Parse CLI arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --credentials=*) credentials="${1#*=}" ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

if [[ -n "$credentials" ]]; then
    echo "Using credentials file: $credentials"
fi

# Build the extra-vars string if credentials are provided
extra_vars=""
if [[ -n "$credentials" ]]; then
    extra_vars="service_account_file=$credentials"
fi

# Run the Ansible playbook with the custom variables
if [[ -n "$extra_vars" ]]; then
    echo "Running Ansible playbook with extra-vars: $extra_vars"
    ansible-playbook playbooks/destroy_compute_instance.yml --extra-vars "$extra_vars"
else
    echo "Running Ansible playbook without extra-vars"
    ansible-playbook playbooks/destroy_compute_instance.yml
fi

exit $?
