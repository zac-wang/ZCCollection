Pod::Spec.new do |s|
  s.name             = 'ZCCollectionView'
  s.version          = '1.0.1'
  s.summary          = 'ZCCollectionView.'

  s.description      = <<-DESC
ZCCollectionView 瀑布流，可混排展示（可设置背景）
                       DESC

  s.homepage         = 'https://github.com/zac-wang/ZCCollection.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'zac_wang' => 'love_iphone@qq.com' }
  s.source           = { :git => 'https://github.com/zac-wang/ZCCollection.git', :tag => s.version.to_s }

  s.platform     = :ios, '9.0'
  s.requires_arc = true

  s.source_files = 'ZCCollectionView/**/*.{h,m}'

  #s.resources    = ['ZCCollectionView/**/*.png']

end
