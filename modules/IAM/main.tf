provider "aws" {
  region = "us-west-2"
}

resource "aws_iam_instance_profile" "test_profile" {
  name = "test_profile"
  role = "${aws_iam_role.test_role.name}"
}

resource "aws_iam_role" "test_role" {
  name = "test_role"

  assume_role_policy = file("./policy_data/policy_data.json")

  tags = {
    tag-key = "tag-value"
  }
}
