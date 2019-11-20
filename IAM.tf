#Create IAM role
resource "aws_iam_role" "ec2_EIP_access_role" {
  name               = "EC2_EIP_role"
  assume_role_policy = file("AssumeRolePolicy.json")
  tags = {
    Name = var.tag_name
  }
}
#Create IAM policy to manage EC2
resource "aws_iam_policy" "ec2_EIP_access_policy" {
  name   = "EC2_EIP_only"
  policy = file("AmazonEC2ElasticIpOnlyAccess.json")
}
#Attach policy to role
resource "aws_iam_role_policy_attachment" "ec2_EIP_access_attach" {
  role       = "${aws_iam_role.ec2_EIP_access_role.name}"
  policy_arn = "${aws_iam_policy.ec2_EIP_access_policy.arn}"
}
#Create instance profile, that will be attached to launch template
resource "aws_iam_instance_profile" "ec2_EIP_access_profile" {
  name = "EC2_EIP_role"
  role = "${aws_iam_role.ec2_EIP_access_role.name}"
}
