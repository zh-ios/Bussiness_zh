Pod::Spec.new do |s|
    s.name             = 'Bussiness_zh'
    s.version          = '1.0.1'
    s.summary          = 'bussiness plugin'
    s.description      = <<-DESC
    TODO: Add long description of the pod here.
    DESC
    s.homepage         = 'https://github.com/zh-ios/Bussiness_zh.git'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'zh' => 'xxx@163.com' }
    s.source           = { :git => 'https://github.com/zh-ios/Bussiness_zh.git', :tag => s.version.to_s }
    s.ios.deployment_target = '8.0'
    s.dependency 'CommonFunction_zhx', '~> 1.0.0'
    s.source_files = 'Bussiness_zh/Classes/**/*'
end
