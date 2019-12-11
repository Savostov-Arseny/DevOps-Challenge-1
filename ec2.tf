#Data sourc to get ami id of Amazon linux
data "aws_ami" "amazon_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*-x86_64-gp2"]
  }

  owners = ["amazon"]
}

#Allocation of a new Elastic IP address
resource "aws_eip" "elastic_ip" {
  vpc = true
  tags = {
    Name = var.tag_name
  }
}
#Create launch template
resource "aws_launch_template" "bastion-host" {
  name_prefix            = "host-launch-template"
  image_id               = "${data.aws_ami.amazon_ami.id}"
  instance_type          = var.instance_type
  user_data              = base64encode(templatefile("user_data.tmpl", { ALLOCATION_ID = "${aws_eip.elastic_ip.id}" }))
  vpc_security_group_ids = ["${aws_security_group.bastion-host.id}"]
  key_name               = var.key_name
  iam_instance_profile {
    name = "EC2_EIP_role"
  }
  tags = {
    Name = var.tag_name
  }

}
#Create autoscaling group using launch template
resource "aws_autoscaling_group" "cheap_HA_host" {
  max_size            = 1
  min_size            = 1
  vpc_zone_identifier = var.vpc_zone_identifier
  launch_template {
    id      = "${aws_launch_template.bastion-host.id}"
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = var.tag_name
    propagate_at_launch = true
  }
}
