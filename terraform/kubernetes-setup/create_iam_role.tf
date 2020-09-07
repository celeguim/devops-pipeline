resource "aws_iam_role" "k8s-role" {
  name               = "k8s-role"
  assume_role_policy = file("policy_assume_role.json")
}

resource "aws_iam_role_policy_attachment" "role-policy-attachment" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEC2FullAccess",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/AmazonRoute53FullAccess",
    "arn:aws:iam::aws:policy/IAMFullAccess"
  ])
  role       = aws_iam_role.k8s-role.name
  policy_arn = each.value
}

resource "aws_iam_instance_profile" "my_iam_profile" {
  name = "test_profile"
  role = aws_iam_role.k8s-role.name
}

