Pod::Spec.new do |s|
  s.name             = "Dawn"
  s.module_name      = 'Dawn'
  s.version          = "2.0.0"
  s.summary          = "A tiny library to make using Date easier."
  s.homepage         = "https://github.com/Meniny/Dawn"
  s.license          = 'MIT'
  s.author           = { "Elias Abel" => "admin@meniny.cn" }
  s.source           = { :git => "https://github.com/Meniny/Dawn.git", :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'
  s.tvos.deployment_target = '9.0'
  s.watchos.deployment_target = '2.0'

  s.source_files = 'Dawn/**/*.{swift,h}'
  s.public_header_files = 'Dawn/**/*.h'
  s.resources = 'Dawn/Resources/Dawn.bundle'

  s.requires_arc     = true
  s.swift_version    = '4.1'

  s.frameworks = 'Foundation'
end
