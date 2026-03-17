resource "yandex_cm_certificate" "lets-encrypt" {
  name = "alexbeznosov-cert"

  domains = [
    "alexbeznosov17032026two.storage.yandexcloud.net"
  ]
  managed {
    challenge_type = "HTTP"
  }
}