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
  image_id               = var.ami
  instance_type          = var.instance_type
  user_data              = base64encode(templatefile("user_data.tmpl", { tag_value = var.tag_name }))
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
