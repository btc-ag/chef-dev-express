property :email, String, sensitive: true
property :password, String, sensitive: true
property :version, String, name_property: true
property :acceptEULA, [true, false], default: false
property :source, String
property :products, Array

action :install do
  main_version = new_resource.version.to_f
  source_url = new_resource.source

  products = ''
  login_data = ''
  eula = ''

  if property_is_set?(:products)
    products = '"' + new_resource.products.join('" "') + '"'
  end

  if property_is_set?(:email) && property_is_set?(:password)
    login_data = "/EMAIL:#{new_resource.email} /PASSWORD:\"#{new_resource.password}\""
  end

  eula = '/EULA:accept' if new_resource.acceptEULA

  windows_package "DevExpress Components #{main_version}" do
    source source_url
    installer_type :custom
    options "/Q #{eula} #{login_data} #{products}"
    timeout 1800
  end
end

action :remove do
  main_version = new_resource.version.to_f
  filename =
    if main_version < 17.0
      "C:\\Program Files (x86)\\DevExpress #{main_version}\\Components\\DevExpressComponents-#{new_resource.version}.exe"
    else
      "C:\\Program Files (x86)\\DevExpress #{main_version}\\Components\\DevExpressNetComponents-#{new_resource.version}.exe"
    end

  execute "Uninstall DevExpress Components #{main_version}" do
    command "\"#{filename}\" /Q -U"
    only_if { ::File.exist?(filename) }
  end

  dev_extreme_path = "C:\\Program Files (x86)\\DevExpress #{main_version}\\DevExtreme\\DevExpressDevExtreme-#{new_resource.version}.exe"

  execute "Uninstall DevExpress DevExtreme  #{main_version}" do
    command "\"#{dev_extreme_path}\" /Q -U"
    only_if { ::File.exist?(dev_extreme_path) }
  end
end
