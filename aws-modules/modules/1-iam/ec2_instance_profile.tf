resource "aws_iam_instance_profile" "this" {
  name =  "${var.environment}-instance-profile"
  role = aws_iam_role.instance_profile.name
}

data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "instance_profile" {
  name               = "${var.environment}-session-manager-access"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

## ALLOW SSM TO MANAGE EC2
resource "aws_iam_role_policy_attachment" "test_attach" {
  role       = aws_iam_role.instance_profile.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}