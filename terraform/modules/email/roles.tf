resource aws_iam_role mini_cloud {
  name = var.name
  assume_role_policy = data.aws_iam_policy_document.instance-assume-role-policy.json
}

data aws_iam_policy_document instance-assume-role-policy {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}
