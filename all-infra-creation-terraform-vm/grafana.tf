#apache-security group
resource "aws_security_group" "grafana-sg" {
  name        = "grafana-sg"
  description = "this is using for securitygroup"
  vpc_id      = aws_vpc.stage-vpc.id

  ingress {
    description = "this is inbound rule"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "this is inbound rule"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["43.225.22.26/32"]
  }
  ingress {
    description     = "this is inbound rule"
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = ["${aws_security_group.alb-sg.id}"]
  }
  ingress {
    description = "this is inbound rule"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description     = "this is inbound rule"
    from_port       = 9090
    to_port         = 9090
    protocol        = "tcp"
    security_groups = ["${aws_security_group.alb-sg.id}"]
    /* cidr_blocks = ["0.0.0.0/0"] */
  }
  ingress {
    description     = "this is inbound rule"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = ["${aws_security_group.bastion.id}"]

  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "grafana-sg"
  }
}
# apache instance
resource "aws_instance" "Grafana" {
  ami                    = var.ami
  instance_type          = var.type
  subnet_id              = aws_subnet.privatesubnet[1].id
  vpc_security_group_ids = [aws_security_group.grafana-sg.id]
  key_name               = aws_key_pair.deployer.id
  iam_instance_profile   = aws_iam_instance_profile.ssm_agent_instance_profile.name
  user_data              = file("scripts/grafana.sh")
  tags = {
    Name = "stage-grafana"
  }
}

resource "null_resource" "prometheus_provisioner" {
  depends_on = [aws_instance.Grafana]

  connection {
    type        = "ssh"
    host        = aws_instance.Grafana.private_ip
    user        = "ec2-user"
    private_key = file("~/.ssh/id_rsa")
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mkdir -p /opt/prometheus",
      "sudo cp ${path.module}/config/prometheus.yml /opt/prometheus/prometheus.yml",
      "sudo chmod 0777 /opt/prometheus/prometheus.yml",
    ]
  }
}