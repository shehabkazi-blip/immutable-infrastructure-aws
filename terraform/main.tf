terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Fetch the latest Golden AMI baked by Packer
data "aws_ami" "golden_image" {
  most_recent = true
  owners      = ["self"]
  filter {
    name   = "name"
    values = ["golden-fintech-ubuntu-*"]
  }
}

resource "aws_launch_template" "app_lt" {
  name_prefix   = "fintech-lt-"
  image_id      = data.aws_ami.golden_image.id
  instance_type = "t3.micro"

  network_interfaces {
    associate_public_ip_address = true
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "Immutable-Prod-Node"
    }
  }
}

resource "aws_autoscaling_group" "app_asg" {
  desired_capacity    = 2
  max_size            = 4
  min_size            = 2
  vpc_zone_identifier = ["subnet-0c2c3d18328c28a55", "subnet-00da61ae3999b01c4"] # Replace with your subnet ID

  launch_template {
    id      = aws_launch_template.app_lt.id
    version = "$Latest"
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
  }
}
