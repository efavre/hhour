APN = Houston::Client.production
APN.certificate = File.read(Rails.root.join('config', 'apple_push_notification_prod.pem')
