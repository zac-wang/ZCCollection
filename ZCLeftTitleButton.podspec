Pod::Spec.new do |s|
  s.name             = 'ZCLeftTitleButton'
  s.version          = '0.1.0'
  s.summary          = 'ZCLeftTitleButton.'

  s.description      = <<-DESC
ZCLeftTitleButton
                       DESC

  s.homepage         = 'https://github.com/zac-wang/demo.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'zac_wang' => 'love_iphone@qq.com' }
  s.source           = { :git => 'https://github.com/zac-wang/demo.git', :tag => s.version.to_s }

  s.platform     = :ios, '9.0'
  s.requires_arc = true

  s.source_files = 'ZCLeftTitleButton/**/*.{h,m}'

  s.resources    = ['ZCLeftTitleButton/**/*.png']

end
