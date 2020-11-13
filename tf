#!/bin/sh
## tf: script to handle terraform infrastructure provisioning
## infrastructure

prog="$0"
me=`basename "$prog"`


##
## Command: help
## Output help commands
## Usage: ./tf help
help () {
  grep '^##' "$prog" | sed -e 's/^##//' -e "s/_PROG_/$me/" 1>&2
}

##
## Command: init
## Initialize the provision env via terraform
## Use: ./tf init
init () {
    if [[ "$2" = "--debug" ]]; then
        echo "DEBUG: TERRAFORM INIT"
        echo "terraform init -backend-config='container_name=terraform-state'"
    fi
    terraform init -backend-config="container_name=terraform-state"
}

##
## Command: plan
## Output the effects the provisioning commands will have
## Use: ./tf plan $environment (prod||staging|dev)
plan () {
    if [[ "$2" = "--debug" ]]; then
        echo "DEBUG: TERRAFORM PLAN"
        echo "terraform plan -var-file='$1.tfvars'"
    fi
    init $@ && terraform plan -var-file="$1.tfvars"
}

##
## Command: show
## Output the effects the provisioning had
## Use: ./tf show
show () {
    terraform show
}

##
## Command: refresh
## The terraform refresh command is used to reconcile the state Terraform knows about (via its state file) with the real-world infrastructure. This can be used to detect any drift from the last-known state, and to update the state file
## Docs: See
## Use: ./tf refresh
refresh () {
    if [[ "$2" = "--debug" ]]; then
        echo "DEBUG: TERRAFORM REFRESH"
        echo "terraform refresh -var-file='$1.tfvars'"
    fi
    init $@ && terraform refresh -var-file="$1.tfvars"
}

##
## Command: destroy
## Destroy the resources created by terraform
## Use: ./tf destroy $environment (prod||staging)
destroy () {
    if [[ "$2" = "--debug" ]]; then
        echo "DEBUG: TERRAFORM DESTROY"
        echo "terraform destroy -var-file='$1.tfvars'"
    fi
    init $@ && terraform destroy -var-file="$1.tfvars"
}

##
## Command: apply
## Run the provisioning commands
## Use: ./tf apply $environment (prod||staging)
apply () {
    if [[ "$2" = "--debug" ]]; then
        echo "DEBUG: TERRAFORM APPLY"
        echo "terraform apply -var-file='$1.tfvars'"
    fi
    init $@ && terraform apply -var-file="$1.tfvars"
}

$1 $2 $3 $4
