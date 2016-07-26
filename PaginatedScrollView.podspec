Pod::Spec.new do |s|
  s.name             = "PaginatedScrollView"
  s.summary          = "Paginated UIScrollView, a simple UIPageViewController alternative."
  s.version          = "0.1.1"
  s.homepage         = "https://github.com/3lvis/PaginatedScrollView"
  s.license          = 'MIT'
  s.author           = { "Elvis Nuñez" => "elvisnunez@me.com" }
  s.source           = { :git => "https://github.com/3lvis/PaginatedScrollView.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/3lvis'
  s.ios.deployment_target = '8.0'
#  s.tvos.deployment_target = '9.0'
  s.requires_arc = true
  s.source_files = 'Sources/**/*'
  s.frameworks = 'UIKit'
end
