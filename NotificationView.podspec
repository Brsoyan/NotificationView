#
#  Be sure to run `pod spec lint NotificationView.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name                        = "NotificationView"
  spec.version                     = "1.0"
  spec.summary                     = "Show messages like push notification success/error/info/loading"
  spec.homepage                    = "https://github.com/Brsoyan/NotificationView"
  spec.license                     = "MIT"
  spec.author                      = { "Brsoyan" => "haykbrsoyan@gmail.com" }
  spec.social_media_url            = "https://www.linkedin.com/in/hayk-brsoyan-33889871/"
  spec.source                      = { :git => "https://github.com/Brsoyan/NotificationView", :tag => "#{spec.version}" }
  spec.source_files                = "Sources*.swift"
  spec.exclude_files               = "Resources/*.pdf", "Resources/*.xib",
  spec.swift_version                  = "4.1"


end
