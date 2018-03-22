source 'https://github.com/CocoaPods/Specs.git'


def pods
    use_frameworks!

    pod 'Astral'
    pod 'RxSwift'
end

target 'RxAstral-iOS' do
    platform :ios, '9.3'
    pods

    target 'RxAstralTests' do
        inherit! :search_paths
        # Pods for testing
    end

end

target 'RxAstral-Mac' do
    platform :macos, '10.11'
    pods

end

target 'RxAstral-tvOS' do
    platform :tvos, '11.0'
    pods

end

target 'RxAstral-watchOS' do
    platform :watchos, '4.0'
    pods

end
