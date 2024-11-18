## GET ACCOUNT_ID
data "aws_caller_identity" "current" {}

## CREATE TRUST ROLE
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codedeploy.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

## CREATE CODE DEPLOY ROLE
resource "aws_iam_role" "code_deploy" {
  name               = "${var.environment}-code-deploy-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

## ATTACH AWS CODE DEPLOY FULL ACCESS POLICY TO CODE DEPLOY ROLE
resource "aws_iam_role_policy_attachment" "AWSCodeDeployFullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
  role       = aws_iam_role.code_deploy.name
}

## ATTACH INLINE POLICY TO ALLOW CODE DEPLOY TO ACCESS ASG
resource "aws_iam_role_policy" "codedeploy_addon" {
  name        = "${var.environment}-cd-asg-policy-addon"
  role        = aws_iam_role.code_deploy.name
  policy = jsonencode({

    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "iam:PassRole",
                "ec2:RunInstances",
                "ec2:CreateTags"
            ],
            "Resource": "*"
        }
    ]
  })
}

## DESCRIBE ACCOUNT ID
locals {
  account_id = data.aws_caller_identity.current.account_id
}

resource "aws_iam_role_policy" "codedeploy_ps_access" {
  name        = "${var.environment}-cd-parameter-store-policy"
  role        = aws_iam_role.code_deploy.id
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
              "ssm:DescribeParameters"
            ],
            "Resource": formatlist( "arn:aws:ssm:ap-southeast-1:${local.account_id}:parameter/%s", var.parameter_store_env_names)
        },
        {
            "Effect": "Allow",
            "Action": [
                "kms:Decrypt"
            ],
            "Resource": "arn:aws:kms:ap-southeast-1:${local.account_id}:alias/aws/ssm"
        }
    ]
  })
}