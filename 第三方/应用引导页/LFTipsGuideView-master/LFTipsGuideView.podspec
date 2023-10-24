Pod::Spec.new do |s|
s.name         = 'LFTipsGuideView'
s.version      = '1.0.1'
s.summary      = 'tips guide'
s.homepage     = 'https://github.com/lincf0912/LFTipsGuideView'
s.license      = 'MIT'
s.author       = { 'lincf0912' => 'dayflyking@163.com' }
s.platform     = :ios
s.ios.deployment_target = '7.0'
s.source       = { :git => 'https://github.com/lincf0912/LFTipsGuideView.git', :tag => s.version, :submodules => true }
s.requires_arc = true
s.source_files = 'LFTipsGuideView/class/*.{h,m}'
s.public_header_files = 'LFTipsGuideView/class/*.h'
s.resources    = 'LFTipsGuideView/class/*.bundle'

end
