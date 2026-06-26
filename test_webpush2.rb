require 'webpush'
require 'openssl'

module Webpush
  class VapidKey
    def self.from_keys(public_key, private_key)
      key = allocate
      pub_bin = Webpush.decode64(public_key)
      priv_bin = Webpush.decode64(private_key)
      
      asn1 = OpenSSL::ASN1::Sequence([
        OpenSSL::ASN1::Integer(1),
        OpenSSL::ASN1::OctetString(priv_bin),
        OpenSSL::ASN1::ObjectId('prime256v1', 0, :EXPLICIT),
        OpenSSL::ASN1::BitString(pub_bin, 1, :EXPLICIT)
      ])
      
      pkey = OpenSSL::PKey.read(asn1.to_der)
      key.instance_variable_set(:@curve, pkey)
      key
    end
    def initialize
      @curve = OpenSSL::PKey::EC.generate('prime256v1')
    end
  end
end

begin
  Webpush.payload_send(
    message: 'Test', 
    endpoint: 'https://fcm.googleapis.com/fcm/send/fake', 
    p256dh: 'fake', 
    auth: 'fake', 
    vapid: {
      subject: 'mailto:sender@example.com', 
      public_key: 'BBtPxaUSC_vCDVuSNlY7nFmHUItTrt6mq1wsKPp8lGr60D096_R_g83uUFmYVLr5gaQzzJwkPQpGBbhxj1wGlBg', 
      private_key: 'NOkxtly50F2_lzb0BE5P2Ow_eEbO7n62wYzRnsrYiXg'
    }
  )
rescue Exception => e
  puts e.class
  puts e.message
  puts e.backtrace
end
