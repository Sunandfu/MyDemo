
Pod::Spec.new do |s|
  s.name             = 'YHLCamera'
  s.version          = '1.0.0'
  s.summary          = '驾驶证、行驶证、身份证拍摄'

  s.description      = <<-DESC


    1、针对驾驶证 行驶证 身份证 拍照后进行剪裁 只保留主体部分， 从而减少图片大小，去除多余干扰部分 ，，特别适合 证件自动设别时使用
    2、确保用户能够准确拍摄 所拍证件的完整性
                       DESC

  s.homepage         = 'https://github.com/yanghl/YHLCamera'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'sean.yang' => '272789124@qq.com' }
  s.source           = { :git => 'https://github.com/yanghl/YHLCamera.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.source_files = 'YHLCamera/Classes/**/*.{h,c,m}'
  s.resources = 'YHLCamera/Classes/**/*.{xib,nib,plist}'
  #s.resource     = 'YHLCamera/YHLCamera2.bundle'
  s.requires_arc = true

end
