Pod::Spec.new do |spec|
  spec.name                   = 'SwiftNet'
  spec.version                = '1.0.0'
  spec.summary                = 'A basic swift networking library'
  spec.homepage               = 'https://github.com/assadjaved/SwiftNet'
  spec.author                 = { 'Asad Javed' => 'assad.j.karim@gmail.com' }
  spec.source                 = { :git => 'https://github.com/assadjaved/SwiftNet.git', :tag => spec.version.to_s }
  spec.ios.deployment_target  = '16.0'
  spec.source_files           = 'SwiftNet/**/*.{swift}'
  spec.frameworks             = 'Foundation'
end

