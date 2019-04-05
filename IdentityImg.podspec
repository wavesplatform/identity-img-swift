Pod::Spec.new do |spec|
  spec.name         = 'IdentityImg'
  spec.ios.deployment_target = '10.0'
  spec.requires_arc = true
  spec.version      = '0.2'
  spec.license      = { :type => '' }
  spec.homepage     = 'https://github.com/wavesplatform/identity-img-swift'
  spec.authors      = { 'Mefilt' => 'mefilt@gmail.com' }
  spec.summary      = 'Mefilt'
  spec.source       = { :git => 'https://github.com/wavesplatform/identity-img-swift.git' }
  spec.source_files = 'IdentityImg/IdentityImg/Source/*.{swift}'  
end
