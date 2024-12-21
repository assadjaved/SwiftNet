Pod::Spec.new do |spec|
  spec.name                   = 'SwiftNet'
  spec.version                = '1.0.0'
  spec.summary                = 'A basic swift networking library'
  spec.homepage               = 'https://github.com/assadjaved/SwiftNet'
  spec.author                 = { 'Asad Javed' => 'assad.j.karim@gmail.com' }
  spec.source                 = { :git => 'https://github.com/assadjaved/SwiftNet.git', :tag => spec.version.to_s }
  spec.ios.deployment_target  = '16.0'
  spec.source_files           = 'SwiftNet/Sources/**/*.{swift,h,m}'
  spec.frameworks             = 'Foundation'
  spec.dependency               'RxSwift'
  
  spec.test_spec 'SwiftNetTests' do |test_spec|
    test_spec.source_files    = 'SwiftNet/Tests/**/*.{swift}'
    test_spec.dependency        'Quick'
    test_spec.dependency        'Nimble'
  end
end
