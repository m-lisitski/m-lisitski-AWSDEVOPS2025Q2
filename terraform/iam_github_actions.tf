resource "aws_iam_openid_connect_provider" "github_actions" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com",
  ]
}

resource "aws_iam_role" "github_actions" {
  name = "rs-school_github_actions"

  assume_role_policy = jsonencode({
    "Statement" = [
      {
        "Action" = "sts:AssumeRoleWithWebIdentity"
        "Condition" = {
          "StringEquals" = {
            "token.actions.githubusercontent.com:aud" = [
              "sts.amazonaws.com",
            ],
            "token.actions.githubusercontent.com:sub" = [
              "repo:m-lisitski/m-lisitski-AWSDEVOPS2025Q2:environment:AWS_rs-school",
            ]
          }
        }
        "Effect" = "Allow"
        "Principal" = {
          "Federated" = aws_iam_openid_connect_provider.github_actions.arn
        }
      },
    ]
    "Version" = "2012-10-17"
  })

}

resource "aws_iam_role_policy_attachment" "github_actions" {
  for_each   = { for index, p in data.aws_iam_policy.admin_role : index => p.arn }
  role       = aws_iam_role.github_actions.name
  policy_arn = each.value
}

