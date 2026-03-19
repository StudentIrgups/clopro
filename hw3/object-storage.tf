resource "yandex_storage_bucket" "storage" {
  bucket   = "alexbeznosov17032026"
  max_size = 1024*1024*1024
  anonymous_access_flags {
    read        = true
    list        = false
    config_read = false
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.key-a.id
        sse_algorithm = "aws:kms"
      }
    }
  }
}

module "certificate" {
    source       = "./certificate"
    vpc_name     = var.vpc_name
    cloud_id     = var.cloud_id
    folder_id    = var.folder_id
}

resource "yandex_storage_bucket" "storage-two" {
  bucket   = "alexbeznosov17032026two"
  max_size = 1024*1024*1024
  anonymous_access_flags {
    read        = true
    list        = false
    config_read = false
  }

  https {
    certificate_id = module.certificate.id
  }

  website {
    index_document = "page-${local_file.picture.filename}"
    
  }
}

resource "local_file" "picture" {
    filename = "my-picture.jpg"
    content_base64 = filebase64("./images/my-picture.jpg")
}

resource "yandex_storage_object" "object" {
  bucket = yandex_storage_bucket.storage.id
  key    = local_file.picture.filename
  source = local_file.picture.filename
  content_type = "jpg"
}

resource "yandex_storage_object" "well-known" {  
  depends_on = [ module.certificate ]
  bucket = yandex_storage_bucket.storage-two.id
  key    = ".well-known/"    
  source = "/dev/null"
}

resource "yandex_storage_object" "acme-challenge" {   
  depends_on = [ yandex_storage_object.well-known ]
  bucket = yandex_storage_bucket.storage-two.id
  key    = ".well-known/acme-challenge/"    
  source = "/dev/null"
}

resource "yandex_storage_object" "content-file" {   
  depends_on = [ yandex_storage_object.acme-challenge ]
  bucket     = yandex_storage_bucket.storage-two.id
  key        = ".well-known/acme-challenge/${module.certificate.file_name}"  
  content    = module.certificate.dns_validation_cname[0].http_content
  content_type = "txt"
} 

resource "yandex_storage_object" "object-two" {   
  bucket = yandex_storage_bucket.storage-two.id
  key    = "page-${local_file.picture.filename}"
  source = local_file.picture.filename
  content_type = "jpg"
}

resource "yandex_kms_symmetric_key" "key-a" {
  name              = "symetric-key"
  description       = "Key for netology"
  default_algorithm = "AES_128"
  rotation_period   = "8760h" 
}
