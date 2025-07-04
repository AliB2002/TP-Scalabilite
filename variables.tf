variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "az1" {
  description = "First Availability Zone"
  type        = string
  default     = "us-east-1a"
}

variable "az2" {
  description = "Second Availability Zone"
  type        = string
  default     = "us-east-1b"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "asg_min_size" {
  description = "Minimum Auto Scaling Group size"
  type        = number
  default     = 1
}

variable "asg_max_size" {
  description = "Maximum Auto Scaling Group size"
  type        = number
  default     = 3
}

variable "asg_desired_capacity" {
  description = "Desired capacity for Auto Scaling Group"
  type        = number
  default     = 1
}

variable "aws_access_key" {
  description = "AWS access key"
  type        = string
  sensitive   = true
}

variable "aws_secret_key" {
  description = "AWS secret key"
  type        = string
  sensitive   = true
}