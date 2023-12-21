resource "aws_iam_role" "role_for_ec2" {
  name = "projectx-ec2-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
      "Service": "ec2.amazonaws.com"
    },
    "Effect": "Allow",
    "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "ec2-additional-policy" {
  name = "projectx-ec2-additional-policy"
policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "*"
        ],
        "Resource": "*"
      } 
    ]
}
EOF
}


resource "aws_iam_role_policy_attachment" "ec2-additional-policy-attachment" {
  role       = aws_iam_role.role_for_ec2.name
  policy_arn = aws_iam_policy.ec2-additional-policy.arn
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "projectx-ec2-instance-profle"
  role = aws_iam_role.role_for_ec2.name
}


resource "aws_instance" "bastion_host" {
  depends_on             = [aws_msk_cluster.kafka]
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.private_key.key_name
  subnet_id              = aws_subnet.public_subnet[0].id
  vpc_security_group_ids = [aws_security_group.bastion_host.id]
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
}

resource "aws_instance" "private_ec2_host" {
  depends_on             = [aws_msk_cluster.kafka]
  ami                    = data.aws_ami.amazon_linux_2023.id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.private_key.key_name
  subnet_id              = aws_subnet.private_subnet[0].id
  vpc_security_group_ids = [aws_security_group.bastion_host.id]
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
}