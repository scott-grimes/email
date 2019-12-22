resource aws_iam_instance_profile mini_cloud {
  name = var.name
  role = aws_iam_role.mini_cloud.name
}
