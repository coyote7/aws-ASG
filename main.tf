terraform {
  required_providers {
    aws={
        source="hashicorp/aws"
        version = ">=4.16"
    }
  }
  #required_version = "~>1.20"
}
resource "aws_launch_configuration" "test-config" {
    image_id = ""
    instance_type = "t2.micro"
    security_groups = [  ]
    user_data = <<-EOF
                #!/bin/bash
                echo "welcome to AWS Launch  config" >index.html
                nohup busybox http -f -p ${var.server-port}$
                EOF
    
}
resource "aws_security_group" "test-sgp" {
    name="test-sgp"
    ingress{
        from_port = var.server-port
        to_port = var.server-port
        cidr_blocks = ["0.0.0.0/0"]
        protocol = "tcp"
    }
}

resource "aws_autoscaling_group" "test-ASG" {
    launch_configuration = aws_launch_configuration.test-config.name
    vpc_zone_identifier = []
    min_size = 2
    max_size = 4
    tag {
      key="Name"
      value="test-ASG"
      propagate_at_launch = true
    }

  
}