output "apache_private_ip" {
  value = aws_instance.apache.private_ip
}

output "jenkins_private_ip" {
  value = aws_instance.jenkins.private_ip
}

output "tomcat_private_ip" {
  value = aws_instance.tomcat.private_ip
}

output "rds_end_point" {
  value = aws_db_instance.default.endpoint
}

output "Frontend_private_ip" {
  value = aws_instance.frontend.private_ip
}

output "Backend_private_ip" {
  value = aws_instance.backend.private_ip
}
