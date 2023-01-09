Pod::Spec.new do |s|
  s.name         = "GenesisSwift"
  s.version      = "1.3.0"
  s.summary      = "iOS Genesis Payment Gateway"
  s.description  = "The iOS Genesis Payment Gateway Swift SDK."
  s.homepage     = "https://github.com/GenesisGateway/ios_sdk.git"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author       = { "eMerchantPay Mobile" => "mobile@emerchantpay.com" }
  s.platform     = :ios
  s.requires_arc = true
  s.ios.deployment_target = "9.0"

  s.source       = { :git => "https://github.com/GenesisGateway/ios_sdk.git", :tag => "#{s.version}" }
  s.source_files = 'GenesisSwift/**/*.{swift}'
  s.swift_version = '4.0'
  s.framework = "UIKit", "Foundation"
end
