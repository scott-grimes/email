resource aws_iam_role_policy_attachment mini_cloud_policy_attachment {
  role       = aws_iam_role.mini_cloud.name
  policy_arn = aws_iam_policy.server_policy.arn
}
