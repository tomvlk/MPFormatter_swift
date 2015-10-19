Pod::Spec.new do |s|
  s.name         = "MPFormatter"
  s.version      = "1.1.1"
  s.summary      = "ManiaPlanet Dollar style parser."

  s.description  = <<-DESC
ManiaPlanet Dollar style parser. See github repo for small documentation and examples on how to use.
                   DESC

  s.homepage     = "https://github.com/tomvlk/MPFormatter_swift"

  s.license      = "MIT"
  s.author    = "Tom Valk"

  s.ios.deployment_target = '8.0'
  s.tvos.deployment_target = '9.0'

  s.source       = { :git => "https://github.com/tomvlk/MPFormatter_swift.git", :tag => s.version }
  s.source_files  = "MPFormatter/*.{h,m,swift}"

  s.requires_arc = true
end
