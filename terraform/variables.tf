variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  default     = "ami-0522ab6e1ddcc7055"  # Replace with a valid AMI ID for your region
}

variable "instance_type" {
  description = "Instance type for the EC2 instance"
  default     = "t2.micro"
}

variable "key_pair" {
  description = "SSH Key Pair"
  default     = "devops"
}

variable "security_group_id" {
  description = "The ID of the existing security group to associate with the instance"
  default     = "sg-0a4b86efefd9999b7"  # Your existing security group ID
}
