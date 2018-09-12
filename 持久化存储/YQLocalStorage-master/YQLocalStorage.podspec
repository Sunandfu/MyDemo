Pod::Spec.new do |s|
  s.name         = "YQLocalStorage"
  s.version      = "0.0.1"
  s.summary      = "iOS SQLite的封装，简单易用"

  s.homepage     = "https://github.com/976431yang/YQLocalStorage"
  s.license      = "MIT"
  s.author       = {'FreakyYang' => '1358970695@qq.com'}
  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/976431yang/YQLocalStorage.git" ,:tag => "#{s.version}"}
  s.public_header_files = "YQLocalStorage/**/*.{h}"
  s.source_files  = "YQLocalStorage/**/*.{h,m,mm}"

end
