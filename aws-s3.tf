resource "aws_s3_bucket" "covid-bucket" {
  bucket = "data-mesh-covid-domain"
  acl    = "private"
  tags = {
    "Environment" = "Dev"
  }
}

resource "aws_s3_bucket" "emr-logging-bucket" {
  bucket = "emr-data-mesh-logging-bucket"
  acl = "private"
}

resource "aws_s3_bucket" "athena-data-mesh-output-bucket" {
  bucket = "athena-data-mesh-output-bucket"
  acl = "private"
}

resource "aws_s3_bucket_policy" "covid-us-bucket-policy" {
  bucket = aws_s3_bucket.covid-bucket.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "COVIDBUCKETPOLICY",
  "Statement": [
    {
      "Sid": "AllowUsCovidTeamMember",
      "Effect": "Allow",
      "Principal": { "AWS" : "${aws_iam_user.covid-us-team-member-user.arn}" },
      "Action": "s3:*",
      "Resource": "${aws_s3_bucket.covid-bucket.arn}/covid-us/*"
    },
    {
      "Sid": "AllowItalyCovidTeamMember",
      "Effect": "Allow",
      "Principal": { "AWS" : "${aws_iam_user.covid-italy-team-member-user.arn}" },
      "Action": "s3:*",
      "Resource": "${aws_s3_bucket.covid-bucket.arn}/covid-italy/*"
    },
    {
      "Sid": "AllowMeFullAccess",
      "Effect": "Allow",
      "Principal": { "AWS" : "arn:aws:iam::150222441608:user/rick101777" },
      "Action": "s3:*",
      "Resource": "${aws_s3_bucket.covid-bucket.arn}/*"
    }
  ]
}
POLICY
}
