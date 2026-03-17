output "dns_validation_cname" {
  value = yandex_cm_certificate.lets-encrypt.challenges
}

output "id" {
  value = yandex_cm_certificate.lets-encrypt.id
}

output "file_name" {
  value = split(".", yandex_cm_certificate.lets-encrypt.challenges[0].http_content)[0]
}
