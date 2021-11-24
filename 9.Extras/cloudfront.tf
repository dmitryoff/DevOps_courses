resource "aws_cloudfront_cache_policy" "gatsby" {
  name        = "gatsby-terraform"
  default_ttl = 86400
  max_ttl     = 31536000
  min_ttl     = 1
  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config {
      cookie_behavior = "whitelist"
      cookies {
        items = ["example"]
      }
    }
    headers_config {
      header_behavior = "whitelist"
      headers {
        items = ["Host"]
      }
    }
    query_strings_config {
      query_string_behavior = "whitelist"
      query_strings {
        items = ["gatsby.dmitryoff.ru"]
      }
    }
    enable_accept_encoding_brotli = true
    enable_accept_encoding_gzip = true
  }
}

resource "aws_cloudfront_origin_request_policy" "gatsby" {
  name    = "gatsby-terraform"
  
  cookies_config {
    cookie_behavior = "whitelist"
    cookies {
      items = ["example"]
    }
  }
  headers_config {
    header_behavior = "whitelist"
    headers {
      items = ["Origin", "Host"]
    }
  }
  query_strings_config {
    query_string_behavior = "none"
  }
}






resource "aws_cloudfront_distribution" "my_web_site" {
  origin {
    domain_name = "${aws_lb.alb.dns_name}"
    origin_id   = "website_access_id" 
    custom_origin_config {
      http_port = 80
      https_port = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }

  enabled = true
    

  aliases = ["gatsby.dmitryoff.ru", "dmitryoff.ru"]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "website_access_id"
    
    origin_request_policy_id = aws_cloudfront_origin_request_policy.gatsby.id
    cache_policy_id = aws_cloudfront_cache_policy.gatsby.id

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.example.arn
    ssl_support_method = "sni-only"  
  }
}

