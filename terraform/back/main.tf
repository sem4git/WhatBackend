terraform {
  backend "s3" {
    bucket = "cf-templates-arixwmuk9m9w-us-east-2"
    key    = "terraform/back/terraform.tfstate"
    region = "us-east-2"
    # encrypt = true
    # kms_key_id = "THE_ID_OF_THE_KMS_KEY"
  }
}
resource "random_string" "rds_password_back" {
  length           = 16
  special          = true
  override_special = "!#*&"
}
provider "aws" {
  region = var.region
  default_tags {
    tags = {
      ita_group = "Dp_206"
      Owner-1   = "Denis Dugar"
      Owner-2   = "Oleksandr Semeriaha"
      Owner-3   = "Andrew Handzha"
    }
  }
}

resource "aws_security_group" "what_back" {
  name        = "What-Back-Security-Group"
  description = "What Back Security Group"
  vpc_id      = data.aws_vpc.what_vpc.id

  dynamic "ingress" {
    for_each = ["80", "5000", "5001"]
    content {
      description = "HTTP to VPC"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# resource "aws_launch_template" "what_back" {
#   name            = "Backend-for-project-What-LT"
#   image_id        = data.aws_ami.latest_ubuntu.id
#   instance_type   = var.instance_type
#   # security_groups = [aws_security_group.back_front.id]
#   user_data       = file("user_data_what_back.sh")

#   lifecycle {
#     create_before_destroy = true
#   }
#  }
resource "aws_launch_configuration" "what_back" {
  name_prefix     = "Backend-for-project-What-LC"
  image_id        = data.aws_ami.latest_ubuntu.id
  instance_type   = var.instance_type
  security_groups = [aws_security_group.what_back.id]
  user_data       = file("user_data_what_back.sh")

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "what_back" {
  name                 = "${aws_launch_configuration.what_back.name}-ASG"
  launch_configuration = aws_launch_configuration.what_back.id
  min_size             = 2
  max_size             = 2
  min_elb_capacity     = 2
  vpc_zone_identifier  = [data.aws_subnet.what_pub_subnet_a.id, data.aws_subnet.what_pub_subnet_b.id]
  health_check_type    = "ELB"
  load_balancers       = [aws_elb.what_back.id]

  lifecycle {
    create_before_destroy = true
  }
  # launch_template {
  #   id      = aws_launch_template.what_back.id
  #   # version = "$Latest"
  # }
  dynamic "tag" {
    for_each = {
      Name      = "What-Back-ASG"
      ita_group = "Dp_206"
      Owner-1   = "Denis Dugar"
      Owner-2   = "Oleksandr Semeriaha"
      Owner-3   = "Andrew Handzha"
    }
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
}
#=================ELB for a Front Instances start===================
resource "aws_elb" "what_back" {
  name = "Backend-for-project-What-ELB"
  # availability_zones = [data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1]]
  subnets         = [data.aws_subnet.what_pub_subnet_a.id, data.aws_subnet.what_pub_subnet_b.id]
  security_groups = [aws_security_group.what_back.id]
  # instances       = [aws_instance.what_front_a.id, aws_instance.what_front_b.id]
  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = 5000
    instance_protocol = "http"
  }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    target              = "HTTP:5000/"
    timeout             = 3
    interval            = 10
  }
}
#=================ELB for a Front Instances end===================
# resource "aws_db_subnet_group" "what_dbsg" {
#   name       = "main"
#   subnet_ids = [aws_subnet.what_private_subnet_a.id, aws_subnet.what_private_subnet_b.id]

#   tags = {
#     Name = "What-DB-subnet-group"
#   }
# }

# resource "aws_db_instance" "db_backend" {
#   allocated_storage    = 10
#   engine               = "mysql"
#   engine_version       = "5.7"
#   instance_class       = "db.t2.micro"
#   name                 = "WhatProd"
#   username             = "root"
#   password             = random_string.rds_password_back.result
#   parameter_group_name = "default.mysql5.7"
#   skip_final_snapshot  = true
#   apply_immediately    = true
#   db_subnet_group_name = aws_db_subnet_group.what_dbsg.name
# }