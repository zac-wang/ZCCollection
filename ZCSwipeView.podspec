Pod::Spec.new do |s|
  s.name             = 'ZCSwipeView'
  s.version          = '0.1.0'
  s.summary          = 'ZCSwipeView.'

  s.description      = <<-DESC
ZCSwipeView
                       DESC

  s.homepage         = 'https://github.com/zac-wang/demo.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'zac_wang' => 'love_iphone@qq.com' }
  s.source           = { :git => 'https://github.com/zac-wang/demo.git', :tag => s.version.to_s }

  s.platform     = :ios, '9.0'
  s.requires_arc = true

  s.source_files = 'ZCSwipeView/**/*.{h,m}'

  s.resources    = ['ZCSwipeView/**/*.png']

end
