
install! 'cocoapods', :disable_input_output_paths => true

source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '14.0'


workspace 'Spendora'

use_frameworks!
inhibit_all_warnings!
enable_bitcode_for_prebuilt_frameworks!


def util_pods
  pod 'SwiftLint'
  pod 'SVProgressHUD'
  pod 'lottie-ios'
  pod 'SDWebImage'
end

def google_pods
  pod 'FirebaseAuth'
  pod 'FirebaseFirestore'
  pod 'FirebaseMessaging'
end

target 'Onboarding' do
    util_pods
end

target 'Authentication' do
  util_pods
  google_pods
end

target 'Spendora' do
    util_pods
    google_pods
end

target 'SpendoraTest' do
  util_pods
  google_pods
end

target 'Utilities' do
    util_pods
    google_pods
end

post_install do |installer|
  installer.generated_projects.each do |project|
    project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '16.0'
      end
    end
  end
end
