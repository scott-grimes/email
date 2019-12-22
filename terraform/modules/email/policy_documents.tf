data aws_iam_policy_document mail_server {

  statement {
    effect    = "Allow"
    resources = ["*"]
    actions   = [
      "ec2:DescribeVolumes",
      "ec2:AttachVolume",
      "s3:PutAnalyticsConfiguration",
      "s3:PutObject",
      "s3:GetObject",
      "s3:ListBucketVersions",
      "s3:ListBucket",
      "s3:GetObjectVersion"
      ]
  }
}
