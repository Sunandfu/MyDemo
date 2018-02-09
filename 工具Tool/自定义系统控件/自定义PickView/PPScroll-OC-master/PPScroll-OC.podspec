#PPScroll-OC.podspec
Pod::Spec.new do |s|
  s.name         = "PPScroll-OC"
  s.version      = "1.0.0"
  s.summary      = "a more general picker which can be used easier! "
  s.homepage     = "https://github.com/CharlieCB/PPScroll-OC"
  s.license      = 'MIT'
  s.author       = { "CharlieCB" => "714645019@qq.com" }
  s.platform     = :ios, "8.0"
  s.ios.deployment_target = "8.0"
  s.source       = { :git => "https://github.com/CharlieCB/PPScroll-OC.git", :tag => s.version}
  s.source_files  = 'PPScroll-OC/PPScroll/*.{h,m}'
  s.requires_arc = true
end