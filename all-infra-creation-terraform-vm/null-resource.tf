/* resource "null_resource" "prometheus_provisioner" {
  connection {
    type        = "ssh"
    host        = aws_instance.Grafana.private_ip
    user        = "ec2-user"
    private_key = file("~/.ssh/id_rsa")
  }

  provisioner "file" {
    content     = <<-EOT
      global:
        scrape_interval: 15s
        evaluation_interval: 15s

      scrape_configs:
        - job_name: 'prometheus'
          static_configs:
            - targets: ["localhost:9090"]

        - job_name: 'node-exporter1'
          static_configs:
            - targets: ["${aws_instance.apache.private_ip}:9100"]
        - job_name: 'node-exporter2'
          static_configs:
            - targets: ["${aws_instance.jenkins.private_ip}:9100"]
        - job_name: 'node-exporter3'
          static_configs:
            - targets: ["${aws_instance.tomcat.private_ip}:9100"]
    EOT
    
    destination = "/opt/prometheus/prometheus.yml"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mkdir -p /opt/prometheus/",
      "sudo chmod 644 /opt/prometheus/prometheus.yml"
    ]
  }
} */