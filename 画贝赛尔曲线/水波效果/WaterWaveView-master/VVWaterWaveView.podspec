Pod::Spec.new do |s|
  s.name             = "VVWaterWaveView"
  s.version          = "0.0.1"
  s.summary          = "VVPopMenuView is a water wave view"
  s.homepage         = "https://github.com/Jasonvvei/WaterWaveView"
  s.license          = 'MIT'
  s.author           = { "Jasonvvei" => "https://github.com/Jasonvvei" }
  s.platform         = :ios, '7.0'
  s.source           = { :git => "https://github.com/Jasonvvei/WaterWaveView.git", :tag => s.version }

  s.source_files     = 'VVWaterWaveView/*.{h,m}'
  s.requires_arc     = true

end