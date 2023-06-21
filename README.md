## Summary

This repository contains a set of different examples of Terraform configuration files for automating Cisco NDO that were used during the **Automating Nexus Dashboard Orchestrator** webinar delivered in EMEA.

## Backend and Credentials

Examples included here use Terraform OSS (CLI) and local backend, and hence state file will be stored locally in the folder of each of the demos.

## Demos

### Demo 01
This demo deploys a basic configuration on NDO, consisting on a tenant, a schema, a set of templates, and several objects inside each of the templates. Finally, the templates are deployed.

However, this demo presents an issue on purpose: template deployment will not be the last resource to run, resulting in a configuration that will only be partially deployed. Following demos will resolve this issue.

To run the demo, use the following commands:

```
$ terraform init
$ terraform plan
$ terraform apply -parallelism 1
```

To clean-up and destroy the created infrastructure in this demo:

```
$ terraform destroy -parallelism 1
```

Note: it's recommended to undeploy templates before destroying, as some provider releases do not undeply the template when undeploying. This can be easily done by changing the local variable `templates_deploy` to `false` under file `tenant_schema.tf`, and running plan+apply again. 

### Demo 02
Building on top of previous demo, this demo resolves the issue with the template not being deployed at the end of the plan. The solution consists on including template configuration in a separated local module. Templates deployers then depends on this module, hence ensuring the correct order of operations.

To run the demo, use the following commands:

```
$ terraform init
$ terraform plan
$ terraform apply -parallelism 1
```

Same in previous demo, created infrastructure can be destroyed using `terraform destroy` command.

### Demo 03
Work in progress

To run the demo, use the following commands:

```
$ terraform init
$ terraform plan
$ terraform apply
```

Same in previous demos, created infrastructure can be destroyed using ```terraform destroy``` command.

