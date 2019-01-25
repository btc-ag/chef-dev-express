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

  if(new_resource.acceptEULA)
    eula = '/EULA:accept'
  end
  
  windows_package "DevExpress Components #{main_version}" do
    source source_url
    installer_type :custom
    options "/Q #{eula} #{login_data} #{products}"
    timeout 1800
  end
end

action :remove do
  main_version = new_resource.version.to_f
  filename = "C:\\Program Files (x86)\\DevExpress #{main_version}\\Components\\DevExpressComponents-#{new_resource.version}.exe"
  execute "Uninstall DevExpress Components #{main_version}" do
    command "\"#{filename}\" /Q -U"
    only_if { ::File.exist?(filename) }
  end
end
