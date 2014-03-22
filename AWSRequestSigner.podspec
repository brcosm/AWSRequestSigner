Pod::Spec.new do |s|
  s.name     = 'AWSRequestSigner'
  s.version  = '0.0.1'
  s.license  = 'MIT'
  s.summary  = 'A library for signing requests to AWS HTTP APIs.'
  s.homepage = 'https://github.com/brcosm/AWSRequestSigner'
  s.authors  = { 'Brandon Smith' => 'brcosm@gmail.com' }
  s.source   = { :git => 'https://github.com/brcosm/S3.git' }
  s.requires_arc = true
  s.source_files = 'Classes'
end