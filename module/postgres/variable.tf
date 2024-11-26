
variable "region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "ap-southeast-1"
}


variable "db_identifier" {
  description = "Identifier for the RDS database"
  type        = string
  default     = "rds"
}


variable "db_name" {
  description = "Database name"
  type        = string
  default     = "test"
}

variable "db_username" {
  description = "Database username"
  type        = string
  default     = "joyjam"
}


variable "allocated_storage" {
  description = "Allocated storage in GB for the RDS database"
  type        = number
  default     = 20
}


variable "db_password" {
  description = "Database password"
  type        = string
  default     = "password"
  # sensitive   = true
}

variable "cpu_threshold" {
  description = "Threshold for CPU utilization"
  type        = number
  default     = 80
}



variable "sns_email" {
  description = "Email address for SNS notifications."
  default     = "------"
}




variable "free_storage_threshold" {
  description = "Threshold for free storage space in bytes"
  type        = number
  default     = 5368709120 # 5 GB
}

variable "connections_threshold" {
  description = "Threshold for database connections"
  type        = number
  default     = 100
}

variable "free_memory_threshold" {
  description = "Threshold for free memory in bytes"
  type        = number
  default     = 1073741824 # 1 GB
}

variable "read_latency_threshold" {
  description = "Threshold for read latency in seconds"
  type        = number
  default     = 1
}

variable "write_latency_threshold" {
  description = "Threshold for write latency in seconds"
  type        = number
  default     = 1
}

variable "monitoring_interval" {
  description = "Interval in seconds for enhanced monitoring. Set to 0 to disable."
  type        = number
  default     = 60
}

#
variable "engine" {
  description = "Database engine type"
  type        = string
  default     = "postgres"
}


variable "major_engine_version" {
  description = "Major version of the database engine"
  type        = string
  default     = "16"
}

variable "instance_class" {
  description = "Instance class for the RDS database"
  type        = string
  default     = "db.t3.micro"
}