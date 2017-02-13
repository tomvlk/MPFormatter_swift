Pod::Spec.new do |s|
  s.name         = "MPFormatter"
  s.version      = "1.2.0"
  s.summary      = "ManiaPlanet Style Parser."

  s.description  = "ManiaPlanet Style Parser. See Github repo for small documentation and examples on how to use."

  s.homepage     = "https://github.com/tomvlk/MPFormatter_swift"

  s.license      = "MIT"
  s.author    = "Tom Valk"

  s.ios.deployment_target = '8.0'
  s.tvos.deployment_target = '9.0'

  s.source       = { :git => "https://github.com/tomvlk/MPFormatter_swift.git", :tag => s.version }

  s.source_files = "MPFormatter/*.{h,m,swift}"

  s.requires_arc = true
end
