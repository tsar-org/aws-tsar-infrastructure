resource "aws_acm_certificate" "tsar_domain_certification" {
  domain_name               = aws_route53_zone.tsar_host_zone.name
  subject_alternative_names = []
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate" "tsar_sub_domain_certification" {
  domain_name               = "*.${aws_route53_zone.tsar_host_zone.name}"
  subject_alternative_names = []
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

# 検証完了までの待機
resource "aws_acm_certificate_validation" "tsar_domain_certificate_validation" {
  certificate_arn         = aws_acm_certificate.tsar_domain_certification.arn
  validation_record_fqdns = [for record in aws_route53_record.tsar_cert_domain_validation : record.fqdn]
}

# 検証完了までの待機
resource "aws_acm_certificate_validation" "tsar_sub_domain_certificate_validation" {
  certificate_arn         = aws_acm_certificate.tsar_sub_domain_certification.arn
  validation_record_fqdns = [for record in aws_route53_record.tsar_cert_sub_domain_validation : record.fqdn]
}
