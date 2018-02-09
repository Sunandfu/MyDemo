Pod::Spec.new do |s|
    s.name         = "CYNavigation"
    s.version      = "1.1.0"
    s.ios.deployment_target = '8.0'
    s.summary      = "A delightful setting interface framework."
    s.homepage     = "https://github.com/zhangchunyu2016/CYNavigation"
    s.license              = { :type => "MIT", :file => "LICENSE" }
    s.author             = { "chunyuZhang" => "707214577@qq.com" }
    s.social_media_url   = "http://www.jianshu.com/u/371e7dfb9a55"
    s.source       = { :git => "https://github.com/zhangchunyu2016/CYNavigation.git", :tag => s.version }
    s.source_files  = "CYNavigation/*.{h,m}"
    s.resources          = "CYNavigation/CYNavigation.bundle"
    s.requires_arc = true
end