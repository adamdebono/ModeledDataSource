Pod::Spec.new do |s|
  s.name         = "ModeledDataSource"
  s.version      = "0.0.1"
  s.summary      = "A wrapper around RxDataSource with models"
  s.homepage     = "http://github.com/adamdebono/ModeledDataSource"
  s.license      = "MIT"
  s.author       = { "Adam Debono" => "adamdebono@gmail.com" }

  s.ios.deployment_target = "5.0"
  s.osx.deployment_target = "10.7"
  s.watchos.deployment_target = "2.0"
  s.tvos.deployment_target = "9.0"

  s.source_files = "Source/*.swift"

  s.dependency "RxSwift", "~> 2.3.1"
  s.dependency "RxDataSources", "~> 0.6.2"

end
