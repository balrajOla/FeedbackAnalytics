# Uncomment this line to define a global platform for your project
platform :ios, '9.0'
# Uncomment this line if you're using Swift
# use_frameworks!

workspace 'FeedbackAnalytics'

project 'FeedbackAnalytics.xcodeproj'

def base_pod
  pod 'Alamofire'
  pod 'PromiseKit'
end

def mainApp_pod
  base_pod
  pod 'CalendarDateRangePickerViewController', :git=>'https://github.com/balrajOla/CalendarDateRangePickerViewController.git'
  pod 'Charts'
  pod 'DropDown'
end

target 'FeedbackAnalytics' do
  project 'FeedbackAnalytics.xcodeproj'
  mainApp_pod
end

target 'FeedbackAnalyticsUnitTests' do
  project 'FeedbackAnalytics.xcodeproj'
  mainApp_pod
end
