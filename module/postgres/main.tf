
provider "aws" {
  region = var.region
}


# Create an IAM Role for RDS Monitoring
resource "aws_iam_role" "rds_monitoring" {
  name               = "${var.db_identifier}-monitoring-role"
  assume_role_policy = data.aws_iam_policy_document.rds_monitoring_assume_policy.json
}

# IAM Policy for RDS Monitoring
data "aws_iam_policy_document" "rds_monitoring_assume_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }
  }
}

# Attach the RDS Monitoring Policy
resource "aws_iam_role_policy_attachment" "rds_monitoring" {
  role       = aws_iam_role.rds_monitoring.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

# Add the RDS Monitoring Role to the RDS module
module "rds" {
  source     = "terraform-aws-modules/rds/aws"
  identifier = var.db_identifier
  version    = "~> 5.0"

  engine               = var.engine
  major_engine_version = var.major_engine_version
  instance_class       = var.instance_class
  allocated_storage    = var.allocated_storage
  db_name              = var.db_name
  username             = var.db_username
  password             = var.db_password

  backup_retention_period = 7
  publicly_accessible     = false
  skip_final_snapshot     = true
  family                  = "postgres16"

  monitoring_interval = 60 # Enable enhanced monitoring (interval in seconds)
  monitoring_role_arn = aws_iam_role.rds_monitoring.arn

  tags = {
    Name = "my-postgres-db"
  }
}

# CloudWatch Alarms 


# CPUUtilization
resource "aws_cloudwatch_metric_alarm" "cpu_utilization" {
  alarm_name          = "${var.db_identifier}-High-CPU"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = var.cpu_threshold

  dimensions = {
    DBInstanceIdentifier = module.rds.db_instance_id
  }

  alarm_actions = [aws_sns_topic.alarm_notifications.arn]
}




resource "aws_sns_topic" "alarm_notifications" {
  name = "${var.db_identifier}-alarm-topic"
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.alarm_notifications.arn
  protocol  = "email"
  endpoint  = var.sns_email # Your email address, e.g., "example@example.com"
}


# db_connections
resource "aws_cloudwatch_metric_alarm" "db_connections" {
  alarm_name          = "${var.db_identifier}-High-Connections"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "DatabaseConnections"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = var.connections_threshold
  dimensions = {
    DBInstanceIdentifier = module.rds.db_instance_id
  }
  alarm_actions = [aws_sns_topic.alarm_notifications.arn]
}




# free_memory
resource "aws_cloudwatch_metric_alarm" "free_memory" {
  alarm_name          = "${var.db_identifier}-Low-Free-Memory"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "FreeableMemory"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = var.free_memory_threshold
  dimensions = {
    DBInstanceIdentifier = module.rds.db_instance_id
  }
  alarm_actions = [aws_sns_topic.alarm_notifications.arn]
}


# ReadLatency

resource "aws_cloudwatch_metric_alarm" "read_latency" {
  alarm_name          = "${var.db_identifier}-High-Read-Latency"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "ReadLatency"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = var.read_latency_threshold
  dimensions = {
    DBInstanceIdentifier = module.rds.db_instance_id
  }
  alarm_actions = [aws_sns_topic.alarm_notifications.arn]
}





# WriteLatency
resource "aws_cloudwatch_metric_alarm" "write_latency" {
  alarm_name          = "${var.db_identifier}-High-Write-Latency"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "WriteLatency"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = var.write_latency_threshold
  dimensions = {
    DBInstanceIdentifier = module.rds.db_instance_id
  }
  alarm_actions = [aws_sns_topic.alarm_notifications.arn]
}
