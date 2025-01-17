#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint shenai_sdk.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'shenai_sdk'
  s.version          = '2.3.7'
  s.summary          = 'Flutter plugin for shen.ai SDK.'
  s.description      = <<-DESC
  Flutter plugin for shen.ai SDK.
                       DESC
  s.homepage         = 'https://developer.shen.ai'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'MX Labs' => 'contact@mxlabs.ai' }
  s.source           = { :path => '.' }

  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '14.0'

  s.vendored_frameworks = 'ShenaiSDK.framework'
  s.preserve_paths = "ShenaiSDK.framework"
  s.pod_target_xcconfig = { 
    'CLANG_CXX_LANGUAGE_STANDARD' => 'c++17',
    'ENABLE_BITCODE' => 'NO', 
    'OTHER_LDFLAGS' => '-framework ShenaiSDK'
  }
end
