#
# Be sure to run `pod lib lint PullToRefreshKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PullToRefreshKit'
  s.version          = '0.8.9'
  s.summary          = 'A refresh library written with pure Swift 5'
  s.description      = <<-DESC
This is a pull to refresh library written by pure Swift 5. Using it you can add pull to refresh, pull to load more, pull left/right to view details within one line. Besides, it is quite easy to write a custom refresh view when using this lib.
                       DESC

  s.homepage         = 'https://github.com/LeoMobileDeveloper/PullToRefreshKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Leo' => 'leomobiledeveloper@gmail.com' }
  s.source           = { :git => 'https://github.com/LeoMobileDeveloper/PullToRefreshKit.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.source_files = 'Sources/PullToRefreshKit/Classes/**/*'
  s.resources    = 'Sources/PullToRefreshKit/Assets/**/*'
end
