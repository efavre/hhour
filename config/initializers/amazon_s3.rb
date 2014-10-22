access_key = ENV['AWS_ACCESS_KEY_ID'] || ""
secret_access_key = ENV['AWS_SECRET_ACCESS_KEY'] || ""
bucket_name = ENV['S3_BUCKET_NAME'] || ""

AWS.config(access_key_id:access_key, secret_access_key: secret_access_key, region: 'eu-west-1' )

S3_BUCKET = AWS::S3.new.buckets[bucket_name]