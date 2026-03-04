resource "yandex_storage_bucket" "storage" {
  bucket   = "alexbeznosov04032026"
  max_size = 1048576
  anonymous_access_flags {
    read        = true
    list        = false
    config_read = false
  }
}

resource "local_file" "picture" {
  filename = "my-picture.png"
  content_base64 = filebase64("./images/0.png")
}

resource "yandex_storage_object" "object" {
  bucket = yandex_storage_bucket.storage.id
  key    = local_file.picture.filename
  source = local_file.picture.filename
  content_type = "png"
}