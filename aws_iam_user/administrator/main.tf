variable "name" {}
variable "tags" {}


resource "aws_iam_user" "administrator" {
  name          = var.name
  force_destroy = true
  tags          = merge(var.tags, {})
}
resource "aws_iam_user_policy" "administrator" {
  user = aws_iam_user.administrator.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : "*",
        "Resource" : "*"
      },
      {
        "Sid" : "DenyAllExceptListedIfNoMFA",
        "Effect" : "Deny",
        "NotAction" : [
          "iam:ChangePassword",
          "iam:CreateVirtualMFADevice",
          "iam:EnableMFADevice",
          "iam:GetUser",
          "iam:ListMFADevices",
          "iam:ListVirtualMFADevices",
          "iam:ResyncMFADevice",
          "sts:GetSessionToken"
        ],
        "Resource" : "*",
        "Condition" : {
          "BoolIfExists" : {
            "aws:MultiFactorAuthPresent" : "false"
          }
        }
      }
    ]
  })
}
