variable "region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "ap-southeast-1"
}

variable "db_identifier" {
  description = "Identifier for the RDS database"
  type        = string
  default     = "rds-mysql"
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "mydb"
}

variable "db_username" {
  description = "Database username"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Database password"
  type        = string
  default     = "mypassword" # Replace with a secure value
}

variable "allocated_storage" {
  description = "Allocated storage in GB for the RDS database"
  type        = number
  default     = 20
}

variable "engine" {
  description = "Database engine type"
  type        = string
  default     = "mysql"
}

variable "major_engine_version" {
  description = "Major version of the database engine"
  type        = string
  default     = "8.0"
}

variable "instance_class" {
  description = "Instance class for the RDS database"
  type        = string
  default     = "db.t3.micro"
}

variable "cpu_threshold" {
  description = "Threshold for CPU utilization"
  type        = number
  default     = 80
}

variable "sns_email" {
  description = "Email address for SNS notifications"
  default     = "example@example.com" # Replace with your email
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

variable "read_throughput_threshold" {
  description = "Threshold for read throughput in bytes/second"
  type        = number
  default     = 100000 # Adjust as needed
}

variable "write_throughput_threshold" {
  description = "Threshold for write throughput in bytes/second"
  type        = number
  default     = 100000 # Adjust as needed
}

variable "read_iops_threshold" {
  description = "Threshold for read IOPS"
  type        = number
  default     = 100
}

variable "write_iops_threshold" {
  description = "Threshold for write IOPS"
  type        = number
  default     = 100
}
