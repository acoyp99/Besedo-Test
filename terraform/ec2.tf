resource "aws_iam_role" "ec2_role" {
  name = "ec2_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_instance" "master_node" {
  ami           = "ami-0261755bbcb8c4a84"
  instance_type = "t2.medium"
  key_name      = "besedo-key"
  subnet_id     = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.ec2_ssh_sg.id]
  associate_public_ip_address = true
  user_data = file("master_userdata.sh")

  tags = {
    Name = "master-node"
  }
}

output "master_public_ip" {
  value = aws_instance.master_node.public_ip
}

resource "aws_instance" "worker_nodes" {
  count = 2
  key_name      = "besedo-key" # Create the key pair with CLI and replace the name
  ami           = "ami-0261755bbcb8c4a84" # Change this to your desired AMI
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private.id
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  vpc_security_group_ids = [aws_security_group.ec2_ssh_sg.id]
  user_data = templatefile("worker_userdata.sh", { master_ip = aws_instance.master_node.public_ip })


  tags = {
    Name = "worker-node-${count.index}"
  }
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_profile"
  role = aws_iam_role.ec2_role.name
}