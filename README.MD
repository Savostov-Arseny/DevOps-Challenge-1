Solution for devops challenge.
===
[![](https://img.youtube.com/vi/E76YJIvq0Zo/0.jpg)](https://www.youtube.com/watch?v=E76YJIvq0Zo)

Task:
---
Create an empty EC2 server to which you can connect via SSH.
That will automatically restarts after terminated with the same IP address.
Assign minimal rights to the server and tag each resource.

How is the task done:
---
- Creates launch template with instance settings, assigned role and bootstrap script.
- Creates an autoscaling group using launch template.
- Allocate new elastic IP.
- Elastic IP address assigns to instance while bootstrap, through aws cli command
`$ aws ec2 associate-address`
- Also creates neccessary resources, such as IAM policy, IAM role, instance profile, security group.

To run this project fill [terraform.tfvars](https://github.com/Savostov-Arseny/DevOps-Challenge-1/blob/master/terraform.tfvars) with your actual variables. 
