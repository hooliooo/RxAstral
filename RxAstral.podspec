#
# Be sure to run `pod lib lint RxAstral.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RxAstral'
  s.module_name      = 'RxAstral'
  s.version          = '0.3.0'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }

  s.summary          = 'An Rx extension to Astral'
  s.homepage         = 'https://github.com/hooliooo/RxAstral'

  s.author           = { 'Julio Alorro' => 'alorro3@gmail.com' }
  s.source           = { :git => 'https://github.com/hooliooo/RxAstral.git', :tag => s.version }

  s.ios.deployment_target = '9.3'
  s.osx.deployment_target = '10.11'
  s.tvos.deployment_target = '11.0'
  s.watchos.deployment_target = '4.0'

  s.source_files = 'Sources/*.swift'
  s.requires_arc = true

  s.frameworks = 'Foundation'
  s.dependency 'Astral'
  s.dependency 'RxSwift'

  s.swift_version = '4.2'

end
