output "instance_id" {
  value = aws_instance.this.id
}

output "public_ip" {
  value = aws_instance.this.public_ip
}
output "cpu_alarm_arn" {
  value = aws_cloudwatch_metric_alarm.cpu_alarm.arn
}