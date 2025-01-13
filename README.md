Ansible Playbook for GCP Compute Instance Configuration
=======================================================

Overview
--------

This guide provides step-by-step instructions to configure and run the modular Ansible playbook for creating and managing a GCP Compute instance. It includes details about installing Ansible, required libraries, default variables, and configuring the `ansible.cfg` file.

* * * * *

Prerequisites
-------------

1.  A GCP project with proper permissions.

2.  A service account JSON key file with the required roles for managing Compute Engine resources.

3.  A local machine with Python 3 installed.

* * * * *

Step 1: Install Ansible and Required Libraries
----------------------------------------------

### Install Ansible

1.  Update your package list and install Ansible:

    ```
    sudo apt update
    sudo apt install ansible -y
    ```

    For macOS:

    ```
    brew install ansible
    ```

    For other operating systems, refer to the Ansible installation guide.

2.  Verify the installation:

    ```
    ansible --version
    ```

### Install Required Python Libraries

1.  Ensure `pip` is installed:

    ```
    sudo apt install python3-pip -y
    ```

2.  Install the required libraries:

    ```
    pip install requests google-auth google-auth-oauthlib google-api-python-client
    ```

### Install Google Cloud SDK

### Install required Ansible collections specified in `requirements.yml`

1. Run `ansible-galaxy install -r requirements.yml`

Setting Up
----------

1.  **Configure the Inventory File**: The `inventory/hosts` file should contain information about the GCP instance or other target hosts.

2.  **Set Default Variables**: Edit `roles/gcp_instance/defaults/main.yml` to define the default values for your resources, such as machine type, image, region, etc.

3.  **Service Account Credentials**: Ensure that you place your `credentials.json` file (from your Google Cloud service account) into `roles/gcp_instance/files/credentials.json`.

4.  **Run the Playbook**: To create and configure a compute instance on GCP, run the following command:

`ansible-playbook -i inventory/hosts playbooks/create_compute_instance.yml`

### Variables

The role uses several variables defined in `roles/gcp_instance/vars/main.yml`. You can modify these variables to fit your specific requirements, such as specifying instance types, regions, etc.Role Variables
--------------

The playbook and role rely on several variables to customize the creation and configuration of your GCP resources. You can find these variables in the `roles/gcp_instance/vars/main.yml` file, and they can be modified to meet your specific requirements.

### Variables Overview:

-   **`project_id`**:\
    The Google Cloud Project ID where the resources will be created.\
    **Example**:

    `project_id: "dkanswers-6e06b"`

-   **`zone`**:\
    The zone in which the compute instance will be created. This determines the physical location of your resources within Google Cloud.\
    **Example**:

    `zone: "us-central1-a"`

-   **`instance_name`**:\
    The name of the compute instance being created. This should be unique within the specified project and zone.\
    **Example**:

    `instance_name: "e2-prod-instance-test"`

-   **`machine_type`**:\
    The machine type defines the specifications (CPU, memory) of the compute instance. For example, `e2-standard-4` represents an instance with 4 vCPUs and 16GB of memory.\
    **Example**:

    `machine_type: "e2-standard-4"`

-   **`disk_size`**:\
    The size of the boot disk in gigabytes. This specifies how much storage the instance will have.\
    **Example**:

    `disk_size: 10`

-   **`disk_type`**:\
    The type of disk to use for the boot disk. Google Cloud offers multiple types of persistent disks, such as `pd-standard` (HDD) and `pd-ssd` (SSD).\
    **Example**:


    `disk_type: "pd-standard"`

-   **`disk_image`**:\
    The image used for the boot disk. This defines the operating system to be installed on the instance. For example, this is set to the latest Ubuntu image.\
    **Example**:

    `disk_image: "projects/ubuntu-os-cloud/global/images/family/ubuntu-2404-lts-amd64"`

-   **`ssh_key_path`**:\
    The path to the SSH private key file that will be used to authenticate to the instance. This key should correspond to the public key added to the instance during creation.\
    **Example**:


    `ssh_key_path: "/Users/syacko/.ssh/prod-sty-holdings-net-scott-yack"`

-   **`service_account_file`**:\
    The path to the Google Cloud service account JSON credentials file. This file is necessary to authenticate Ansible to your Google Cloud account. It should be placed in the `roles/gcp_instance/files/` directory.\
    **Example**:

    `service_account_file: "{{ role_path }}/files/credentials.json"`

-   **`firewall_ports`**:\
    A list of ports to open in the firewall for the instance. By default, ports 22 (SSH), 4222 (NATS), and 9222 (debugging) are open. You can add or remove ports as needed.\
    **Example**:

    `firewall_ports:
      - "22"       # SSH
      - "4222"     # NATS
      - "9222"     # Debugging`

### Example `vars/main.yml`:

`project_id: "dkanswers-6e06b"
zone: "us-central1-a"
instance_name: "e2-prod-instance-test"
machine_type: "e2-standard-4"
disk_size: 10
disk_type: "pd-standard"
disk_image: "projects/ubuntu-os-cloud/global/images/family/ubuntu-2404-lts-amd64"
ssh_key_path: "/Users/syacko/.ssh/prod-sty-holdings-net-scott-yack"
service_account_file: "{{ role_path }}/files/credentials.json"
firewall_ports_ssh: "22"
firewall_ports_nats: "4222"
firewall_ports_nats_websocket: "9222"

### Modifying Variables:

You can override any of these variables when running the playbook. For example, to specify a different project ID or zone, you can pass the values via the `-e` option when running the playbook:


`ansible-playbook -i inventory/hosts playbooks/create_compute_instance.yml -e "project_id=my-project-id zone=us-west1-b"`


Running with Bash Scripts
=======================================

This repository contains two bash scripts for managing GCP Compute Instances using Ansible.

1.  `create_gcp_instance.sh` - Used to create and configure a GCP Compute Instance.
2.  `destroy_gcp_instance.sh` - Used to destroy a GCP Compute Instance.

Both scripts are designed to be used with Ansible playbooks for creating and destroying Compute Instances on Google Cloud Platform (GCP).

* * * * *

Prerequisites
-------------

Before using these scripts, ensure the following:

-   You have **Ansible** installed on your machine.
-   You have the **Google Cloud SDK** installed and configured with a GCP project.
-   You have a **service account JSON key file** for GCP with the necessary permissions for managing Compute Instances.

* * * * *

Script 1: `create_gcp_instance.sh`
----------------------------------

### Description

This script is used to create and configure a GCP Compute Instance using an Ansible playbook.

### Usage

`./create_gcp_instance.sh [--protect=true|false] [--credentials=/path/to/service-account.json] [--ssh_key_path=/path/to/ssh-key]`

### Parameters

-   `--protect=true|false`: (Optional) Set **deletion protection** for the instance. Default is `false`.
-   `--credentials=/path/to/service-account.json`: (Required) Path to the service account JSON key file used for authentication with GCP.
-   `--ssh_key_path=/path/to/ssh-key`: (Optional) Path to the SSH key used for connecting to the instance.

### Example

Create a GCP Compute Instance with deletion protection enabled:


`./create_gcp_instance.sh --protect=true --credentials=/path/to/service-account.json --ssh_key_path=/path/to/ssh-key

* * * * *

Script 2: `destroy_gcp_instance.sh`
-----------------------------------

### Description

This script is used to destroy (delete) a GCP Compute Instance using an Ansible playbook.

### Usage


`./destroy_gcp_instance.sh [--credentials=/path/to/service-account.json]`

### Parameters

-   `--credentials=/path/to/service-account.json`: (Required) Path to the service account JSON key file used for authentication with GCP.

### Example

Destroy a GCP Compute Instance:


`./destroy_gcp_instance.sh --credentials=/path/to/service-account.json`

* * * * *

Ansible Playbook Structure
--------------------------

Both scripts reference specific Ansible playbooks to perform the tasks.

-   **For Creating Instances**: `playbooks/create_compute_instance.yml`
-   **For Destroying Instances**: `playbooks/destroy_compute_instance.yml`

Ensure that these playbooks are configured correctly for your GCP setup.

* * * * *

Troubleshooting
---------------

-   Ensure that the provided `service-account.json` file has the correct IAM permissions to manage GCP Compute Instances.
-   Double-check the `ssh_key_path` to ensure the SSH key exists and has proper permissions for access.
-   If any errors occur with Ansible, check the output logs for more details and ensure that your Ansible environment is properly configured.