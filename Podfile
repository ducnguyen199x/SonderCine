platform :ios, '13.0'
# ignore warnings from all pods
inhibit_all_warnings!

def base_pods
    pod 'RxSwift'
    pod 'RxCocoa'
    pod 'NSObject+Rx'
    pod 'Alamofire'
    pod 'SwiftLint'
    pod 'Kingfisher'
    pod 'TinyConstraints'
    pod 'R.swift'
end

def ui_pods
    pod 'IQKeyboardManager'
    pod 'SVProgressHUD'
    pod 'FLEX', :configurations => ['Debug']
end

target 'SonderCine' do
  use_frameworks!

  base_pods
  ui_pods
  
  # Pods for SonderCine

  target 'SonderCineTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'SonderCineUITests' do
    # Pods for testing
  end

end

post_install do |pi|
    pi.pods_project.targets.each do |t|
      t.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      end
    end
end
