## ATTACH INLINE POLICY TO ALLOW CODE DEPLOY TO ACCESS ASG
resource "aws_iam_policy" "ec2_access_to_artifact_and_codedeploy" {
  name        = "${var.environment}-cd-s3-access-policy-addon"
  path        = "/"
  description = "Allow EC2 Role to access artifacts in s3 as well as code-deploy agents"
  policy = jsonencode({

    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "s3:Get*",
          "s3:List*"
        ],
        "Resource" : [
          "arn:aws:s3:::clairrs-code-artifact/*",
          "arn:aws:s3:::aws-codedeploy-us-east-2/*",
          "arn:aws:s3:::aws-codedeploy-us-east-1/*",
          "arn:aws:s3:::aws-codedeploy-us-west-1/*",
          "arn:aws:s3:::aws-codedeploy-us-west-2/*",
          "arn:aws:s3:::aws-codedeploy-ca-central-1/*",
          "arn:aws:s3:::aws-codedeploy-eu-west-1/*",
          "arn:aws:s3:::aws-codedeploy-eu-west-2/*",
          "arn:aws:s3:::aws-codedeploy-eu-west-3/*",
          "arn:aws:s3:::aws-codedeploy-eu-central-1/*",
          "arn:aws:s3:::aws-codedeploy-eu-central-2/*",
          "arn:aws:s3:::aws-codedeploy-eu-north-1/*",
          "arn:aws:s3:::aws-codedeploy-eu-south-1/*",
          "arn:aws:s3:::aws-codedeploy-eu-south-2/*",
          "arn:aws:s3:::aws-codedeploy-il-central-1/*",
          "arn:aws:s3:::aws-codedeploy-ap-east-1/*",
          "arn:aws:s3:::aws-codedeploy-ap-northeast-1/*",
          "arn:aws:s3:::aws-codedeploy-ap-northeast-2/*",
          "arn:aws:s3:::aws-codedeploy-ap-northeast-3/*",
          "arn:aws:s3:::aws-codedeploy-ap-southeast-1/*",
          "arn:aws:s3:::aws-codedeploy-ap-southeast-2/*",
          "arn:aws:s3:::aws-codedeploy-ap-southeast-3/*",
          "arn:aws:s3:::aws-codedeploy-ap-southeast-4/*",
          "arn:aws:s3:::aws-codedeploy-ap-south-1/*",
          "arn:aws:s3:::aws-codedeploy-ap-south-2/*",
          "arn:aws:s3:::aws-codedeploy-me-central-1/*",
          "arn:aws:s3:::aws-codedeploy-me-south-1/*",
          "arn:aws:s3:::aws-codedeploy-sa-east-1/*"
        ]
      }
    ]
  })
}


## BIND POLICY TO INSTANCE ROLE
resource "aws_iam_role_policy_attachment" "add_s3_access" {
  policy_arn = aws_iam_policy.ec2_access_to_artifact_and_codedeploy.arn
  role       = aws_iam_role.instance_profile.name
  depends_on = [ aws_iam_policy.ec2_access_to_artifact_and_codedeploy ]
}