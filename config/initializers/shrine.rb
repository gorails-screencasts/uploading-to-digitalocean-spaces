require 'shrine/storage/s3'

s3_options = {
  access_key_id: Rails.application.secrets.digitalocean_spaces_key,
  secret_access_key: Rails.application.secrets.digitalocean_spaces_secret,
  bucket: Rails.application.secrets.digitalocean_spaces_bucket,
  endpoint: 'https://nyc3.digitaloceanspaces.com',
  region: 'nyc3'
}

Shrine.storages = {
  cache: Shrine::Storage::S3.new(prefix: 'cache', upload_options: {acl: 'public-read'}, **s3_options),
  store: Shrine::Storage::S3.new(prefix: 'store', upload_options: {acl: 'public-read'}, **s3_options),
}

Shrine.plugin :activerecord
