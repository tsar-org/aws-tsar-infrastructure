resource "aws_route53_zone" "tsar_host_zone" {
  name = "aws.tsar-bmb.org"
}

// Domain validation for the main domain
resource "aws_route53_record" "tsar_cert_domain_validation" {
  for_each = {
    for dvo in aws_acm_certificate.tsar_domain_certification.domain_validation_options : dvo.domain_name => {
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
  zone_id         = aws_route53_zone.tsar_host_zone.zone_id
}

// Domain validation for the sub domain
resource "aws_route53_record" "tsar_cert_sub_domain_validation" {
  for_each = {
    for dvo in aws_acm_certificate.tsar_sub_domain_certification.domain_validation_options : dvo.domain_name => {
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
  zone_id         = aws_route53_zone.tsar_host_zone.zone_id
}
