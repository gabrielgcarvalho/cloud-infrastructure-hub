# Multi-Environment Infrastructure Example

This is a multi-environment infrastructure project that uses Terragrunt and Terraform to manage resources across different environments (dev, staging, and production) in AWS. The project is organized into separate directories for each environment, making it easy to manage and deploy infrastructure configurations for specific environments.

## Prerequisites

Before getting started, ensure you have the following installed on your local machine:

1. [Terraform](https://www.terraform.io/downloads.html)
2. [Terragrunt](https://terragrunt.gruntwork.io/docs/getting-started/install/)

## Project Structure

The project should be organized as follows:

```
|-- env
|	|-- dev
|	    |-- terragrunt.hcl
|       |-- terragrunt_vars.hcl
|	|-- staging
|	    |-- terragrunt.hcl
|       |-- terragrunt_vars.hcl
|	|-- production
|	    |-- terragrunt.hcl
|       |-- terragrunt_vars.hcl
|-- scripts (optional)
|-- template ( optional )
|-- tests (optional)
```

In this project, we have a top-level directory called env, which contains subdirectories for different environments: dev, staging, and production. Each environment directory will contain the Terraform configuration files specific to that environment.

## Optional Directories

The project also includes some optional directories:

1. scripts: This directory can be used to store any custom scripts or shell files required for provisioning or configuration tasks. It is not mandatory for every environment to have this directory, but you can include it as needed.

2. template: The template directory can be utilized to store template files used in your infrastructure, such as configuration files or HTML templates. Similar to the scripts directory, this is optional and can be included when needed.

3. tests: The tests directory can contain any test scripts or configurations to verify your infrastructure's correctness. This directory is also optional and can be used based on your project requirements.

## Using Variable Files

To execute Terragrunt successfully and customize your infrastructure for different environments, ensure the following:

1. `terragrunt.hcl` : In each environment directory (dev, staging, and production), you should have a terragrunt.hcl file, like the example provided, that includes the root block:
   ```
   include "root" {
        path = find_in_parent_folders()
    }
   ```
2. `terragrunt_vars.hcl` : Additionally, in each environment directory (dev, staging, and production), you should create a terragrunt_vars.hcl file that defines specific variable values for each environment. For example:
   ```
   locals {
        project = "my-awesome-project"
        env     = "dev"
        region  = "us-east-2"
        prefix  = "${local.project}/${local.env}"
    }
   ```
   Customize the values of project, env, region, and prefix to match the requirements of each environment.
