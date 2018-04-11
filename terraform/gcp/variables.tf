# This file contains variables that are used in project.
# If the value of these variables is not defined in terraform.tfvars file they be asked at the runtime

variable  "pname"{} # Project Name
variable "project_id"{}  # Project id that you created
variable "creds_file"{} # Json file downloaded from googlec cloud which will provide access to Gcloud Resources
variable  "region"{} # Geographical Region in which we have to create the resources

variable  "machine_type"{} # The Capacity of VM that we wnat to create
variable "startup_script"{} # File which will be used as bootstrap script
variable "count" {
  default = "1"
}
variable "ssh_key" {}
variable "cidr" {
  default = "0.0.0.0/0"
}
