#!/bin/bash
sudo yum update -y 
sudo yum install telnet nc net-tools httpd -y 
sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
sudo systemctl start amazon-ssm-agent
sudo systemctl enable amazon-ssm-agent
# sudo wget https://github.com/prometheus/prometheus/releases/download/v2.39.1/prometheus-2.39.1.linux-amd64.tar.gz
# tar -xf prometheus-2.39.1.linux-amd64.tar.gz
# cd prometheus-2.39.1.linux-amd64/
sudo wget https://dl.grafana.com/oss/release/grafana-9.2.1.linux-amd64.tar.gz
tar -xvzf grafana-9.2.1.linux-amd64.tar.gz
chmod -R 755 grafana-9.2.1
cd grafana-9.2.1/bin/
nohup ./grafana-server & 
cd /tmp
wget https://github.com/prometheus/prometheus/releases/download/v2.39.1/prometheus-2.39.1.linux-amd64.tar.gz
tar -xf prometheus-2.39.1.linux-amd64.tar.gz
mv prometheus-2.39.1.linux-amd64 prometheus
cp -r * /opt
chmod 755 /opt/prometheus
cd /opt/prometheus
echo '
    global:
      scrape_interval: 15s
      evaluation_interval: 15s

    # Alertmanager configuration
    alerting:
      alertmanagers:
        - static_configs:
            - targets:
                - alertmanager:9093

    # Load rules once and periodically evaluate them according to the global 'evaluation_interval'.
    rule_files:
      - "first_rules.yml"
      - "second_rules.yml"

    # A scrape configuration containing Prometheus and node-exporter as targets.
    scrape_configs:
      - job_name: "prometheus"
        static_configs:
          - targets: ["localhost:9090"]

      - job_name: "node-exporter"
        static_configs:
          - targets: ["${aws_instance.node_exporter.private_ip}:9100"]

      - job_name: "tomcat"
        static_configs:
          - targets: ["${aws_instance.tomcat.private_ip}:8080"]' > prometheus.yml

    # Start Prometheus in the background using nohup
    nohup ./prometheus > /dev/null 2>&1 &
    EOT

