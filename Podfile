
install! 'cocoapods', :disable_input_output_paths => true

source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '14.0'


workspace 'Spendora'

use_frameworks!
inhibit_all_warnings!
enable_bitcode_for_prebuilt_frameworks!


def util_pods
  pod 'SwiftLint'
end

target 'Onboarding' do
    util_pods
end

target 'Spendora' do
    util_pods
end

target 'Utilities' do
    util_pods
end
