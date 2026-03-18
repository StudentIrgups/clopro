resource "yandex_cm_certificate" "lets-encrypt" {
  name = "alexbeznosov-cert"

  domains = [
    "alexbeznosov17032026two.storage.yandexcloud.net"
  ]
  managed {
    challenge_type = "HTTP"
  }
}

resource "yandex_cm_certificate" "lets-encrypt-2" {
  name = "alexbeznosov-cert-2"

  domains = [
    "alexbeznosov17032026two.website.yandexcloud.net"
  ]
  managed {
    challenge_type = "DNS_CNAME"
  }
}