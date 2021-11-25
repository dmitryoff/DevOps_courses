provider "aws" {
  alias = "env"
  region = "eu-west-1"
}

provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"
}

resource "aws_route53_zone" "primary" {
  name = "dmitryoff.ru"
}

resource "aws_acm_certificate" "example" {
  provider = aws.us-east-1
  domain_name               = "dmitryoff.ru"
  subject_alternative_names = ["*.dmitryoff.ru"]
  validation_method         = "DNS"
}

resource "aws_route53_record" "main" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "dmitryoff.ru"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.my_web_site.domain_name
    zone_id                = "Z2FDTNDATAQYW2"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "gatsby" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "gatsby.dmitryoff.ru"
  type    = "A"
  
  alias {
    name                   = aws_cloudfront_distribution.my_web_site.domain_name
    zone_id                = "Z2FDTNDATAQYW2"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "example" {
  for_each = {
    for dvo in aws_acm_certificate.example.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.primary.zone_id
}

resource "aws_acm_certificate_validation" "example" {
  provider = aws.us-east-1
  certificate_arn         = aws_acm_certificate.example.arn
}