# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'LiveMArket' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for LiveMArket
  pod 'Firebase/Database' ,'>10.22.0'
  pod 'Firebase/Messaging' ,'>10.22.0'
  pod 'Firebase/Auth' ,'>10.22.0'
  pod 'Firebase/Core' ,'>10.22.0'
  pod 'Firebase/Crashlytics' ,'>10.22.0'
  pod 'Firebase/Storage' ,'>10.22.0'
  pod 'IQKeyboardManagerSwift'
  pod 'ImageSlideshow'
  pod 'ImageSlideshow/Alamofire'
  pod 'KMPlaceholderTextView', '~> 1.4.0'
  pod 'Alamofire', '~> 5.0'
  pod 'NVActivityIndicatorView'
  pod 'SDWebImage'
  #pod 'IQKeyboardManager'
  pod 'CHIPageControl'
  pod 'FaveButton'
  pod "PWSwitch"
  pod 'DatePickerDialog'
  pod 'YLProgressBar'
  pod 'DropDown'
  pod 'GooglePlaces', '~> 7.4.0'
  pod 'GoogleMaps', '~> 7.4.0'
  pod 'GoogleSignIn'
  pod 'Stripe', '~> 22.8.2'
  pod 'Cosmos'
  pod 'FittedSheets'
  pod 'SwiftKeychainWrapper'
  pod 'STRatingControl'
  pod 'Siren'
  pod 'CountryPickerView'
  pod 'DPOTPView'
  pod 'HSAttachmentPicker'
  pod 'OpalImagePicker'
  pod 'GrowingTextView', '0.6.1'
  pod 'SCLAlertView'
  #pod 'ImageViewer'
  pod 'ImageViewer.swift'
  pod 'SideMenu'
  pod 'Appirater'
  pod 'lottie-ios'
  pod 'HSCycleGalleryView'
  pod 'FloatRatingView', '~> 4'
  pod 'FSCalendar'
  pod 'FSPagerView'
  pod "PageControls"
  
  pod 'Texture', '~> 3.0.0'
  pod 'ASPVideoPlayer'
  #pod 'ACThumbnailGenerator-Swift'#50
  pod "ExpandableLabel"#51
  pod 'SkeletonView'#33
  pod 'GSPlayer'#37
  pod 'SwiftEventBus', :tag => '5.1.0', :git => 'https://github.com/cesarferreira/SwiftEventBus.git' #1
  pod "AsyncSwift"
  pod 'EZPlayer'
  #pod 'ContextMenuSwift'
  pod 'KeychainAccess'
  pod 'XLPagerTabStrip', '~> 9.0'
  pod "AlignedCollectionViewFlowLayout"
  pod 'MultiSlider'
  pod 'Lightbox'
  pod 'Firebase/DynamicLinks'
  pod 'SoundModeManager', '~> 1.0.1'
  pod 'SwiftGifOrigin', '~> 1.7.0'
  pod 'AudioStreaming', '~> 0.9.0'
  pod 'PIPKit', '~> 1.0.7'
  pod 'UIPiPView', :git => 'https://github.com/uakihir0/UIPiPView/', :branch => 'main'
  pod 'goSellSDK'
  pod 'TapApplePayKit-iOS'
  pod 'Socket.IO-Client-Swift', '~> 15.2.0'
  target 'LiveMArketTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'LiveMArketUITests' do
    # Pods for testing
  end

end

post_install do |installer|
  installer.generated_projects.each do |project|
    project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
      end
    end
  end
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      xcconfig_path = config.base_configuration_reference.real_path
      xcconfig = File.read(xcconfig_path)
      xcconfig_mod = xcconfig.gsub(/DT_TOOLCHAIN_DIR/, "TOOLCHAIN_DIR")
      File.open(xcconfig_path, "w") { |file| file << xcconfig_mod }
    end
  end
end
