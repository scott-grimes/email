resource aws_iam_policy server_policy {
  name   = "server_policy"
  policy = data.aws_iam_policy_document.mail_server.json
}
