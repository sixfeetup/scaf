resource "aws_iam_user" "cnpg_user" {
  name = "${var.app_name}-${var.environment}-cnpg-user"

  tags = local.common_tags
}

resource "aws_iam_access_key" "cnpg_user_key" {
  user = aws_iam_user.cnpg_user.name
}

resource "aws_iam_user_policy_attachment" "cnpg_user_policy_attachment" {
  user       = aws_iam_user.cnpg_user.name
  policy_arn = aws_iam_policy.s3_rw_policy.arn
}
{% if cookiecutter.mail_service == "Amazon SES" %}

resource "aws_iam_user" "amazon_ses_user" {
  name = "${var.app_name}-${var.environment}-ses-user"

  tags = local.common_tags
}

resource "aws_iam_access_key" "amazon_ses_user_key" {
  user = aws_iam_user.amazon_ses_user.name
}

resource "aws_iam_user_policy_attachment" "amazon_ses_user_policy_attachment" {
  user       = aws_iam_user.amazon_ses_user.name
  policy_arn = aws_iam_policy.amazon_ses_policy.arn
}
{% endif %}
