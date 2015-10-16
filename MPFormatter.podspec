Pod::Spec.new do |s|
  s.name         = "MPFormatter"
  s.version      = "1.0.0"
  s.summary      = "ManiaPlanet Dollar style parser."

  s.description  = <<-DESC
ManiaPlanet Dollar style parser. See github repo for small documentation and examples on how to use.
                   DESC

  s.homepage     = "https://github.com/tomvlk/MPFormatter_swift"

  s.license      = "MIT"
  s.author    = "Tom Valk"

  s.platform	   = :ios, "8.0"

  s.source       = { :git => "https://github.com/tomvlk/MPFormatter_swift.git", :tag => s.version }
  s.source_files  = "MPFormatter/*.{h,m,swift}"

  s.requires_arc = true
end
