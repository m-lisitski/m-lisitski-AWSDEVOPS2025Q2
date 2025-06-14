resource "aws_iam_openid_connect_provider" "github_actions" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "https://github.com/m-lisitski",
  ]
}


resource "aws_iam_role" "githab_actions" {
  name = "rs-school_github_actions"

  assume_role_policy = jsonencode({
    "Statement" = [
      {
        "Action" = "sts:AssumeRoleWithWebIdentity"
        "Condition" = {
          "StringEquals" = {
            "token.actions.githubusercontent.com:aud" = [
              "https://github.com/m-lisitski",
            ]
          }
          "StringLike" = {
            "token.actions.githubusercontent.com:sub" = [
              "repo:m-lisistski/m-lisitski:environment:AWS_rs-school",
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

resource "aws_iam_role_policy_attachment" "githab_actions" {
  for_each   = { for index, p in data.aws_iam_policy.admin_role : index => p.arn }
  role       = aws_iam_role.githab_actions.name
  policy_arn = each.value
}

