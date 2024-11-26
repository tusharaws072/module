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
  family                  = "mysql8.0"

  monitoring_interval = 60
  monitoring_role_arn = aws_iam_role.rds_monitoring.arn

  tags = {
    Name = "my-mysql-db"
  }
}

# CloudWatch Alarms
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
  endpoint  = var.sns_email
}




#  FreeStorageSpace

resource "aws_cloudwatch_metric_alarm" "free_storage_space" {
  alarm_name          = "${var.db_identifier}-Low-Free-Storage"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = var.free_storage_threshold

  dimensions = {
    DBInstanceIdentifier = module.rds.db_instance_id
  }

  alarm_actions = [aws_sns_topic.alarm_notifications.arn]
}

# DatabaseConnections

resource "aws_cloudwatch_metric_alarm" "database_connections" {
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


# FreeableMemory

resource "aws_cloudwatch_metric_alarm" "freeable_memory" {
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

# ReadThroughput

resource "aws_cloudwatch_metric_alarm" "read_throughput" {
  alarm_name          = "${var.db_identifier}-Low-Read-Throughput"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "ReadThroughput"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = var.read_throughput_threshold

  dimensions = {
    DBInstanceIdentifier = module.rds.db_instance_id
  }

  alarm_actions = [aws_sns_topic.alarm_notifications.arn]
}

# WriteThroughput

resource "aws_cloudwatch_metric_alarm" "write_throughput" {
  alarm_name          = "${var.db_identifier}-Low-Write-Throughput"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "WriteThroughput"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = var.write_throughput_threshold

  dimensions = {
    DBInstanceIdentifier = module.rds.db_instance_id
  }

  alarm_actions = [aws_sns_topic.alarm_notifications.arn]
}

# ReadIOPS

resource "aws_cloudwatch_metric_alarm" "read_iops" {
  alarm_name          = "${var.db_identifier}-Low-Read-IOPS"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "ReadIOPS"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = var.read_iops_threshold

  dimensions = {
    DBInstanceIdentifier = module.rds.db_instance_id
  }

  alarm_actions = [aws_sns_topic.alarm_notifications.arn]
}

# WriteIOPS

resource "aws_cloudwatch_metric_alarm" "write_iops" {
  alarm_name          = "${var.db_identifier}-Low-Write-IOPS"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "WriteIOPS"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = var.write_iops_threshold

  dimensions = {
    DBInstanceIdentifier = module.rds.db_instance_id
  }

  alarm_actions = [aws_sns_topic.alarm_notifications.arn]
}
