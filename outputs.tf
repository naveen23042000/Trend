output "ec2_instance_public_ip" {
  description = "Public IP of the Jenkins EC2 instance"
  value       = aws_instance.jenkins_ec2.public_ip
}

output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.main_vpc.id
}

output "iam_instance_profile_name" {
  description = "Name of the IAM instance profile"
  value       = aws_iam_instance_profile.ec2_profile.name
}
