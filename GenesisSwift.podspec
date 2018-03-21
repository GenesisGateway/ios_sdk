Pod::Spec.new do |s|
s.name             = "GenesisSwift"
s.version          = "1.0.0"
s.summary          = "The iOS Genesis Payment Gateway Swift SDK."
s.homepage         = "https://github.com/GenesisGateway/ios_sdk.git"
s.authors          = { '' => '' }
s.license          = { :type => "MIT", :file => "LICENSE" }
s.source           = { :git => "https://github.com/GenesisGateway/ios_sdk.git", :tag => s.version }

s.platform     = :ios, '9.0'
s.requires_arc = true

s.source_files = 'GenesisSwift/**/*.swift'

s.frameworks = 'UIKit', 'Foundation'
s.module_name = 'GenesisSwift'
end
