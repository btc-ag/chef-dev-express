# Dev Express cookbook

[![Build Status](https://dev.azure.com/btcag-chef/chef/_apis/build/status/btc-ag.chef-dev-express?branchName=master)](https://dev.azure.com/btcag-chef/chef/_build/latest?definitionId=4&branchName=master)
[![Cookbook version](https://img.shields.io/cookbook/v/dev_express.svg?style=flat)](https://supermarket.chef.io/cookbooks/dev_express)

This cookbook can be configured to install DevExpress

it defines a custom resource called `dev_express`.
As dev express cannot be downlaoded by a public repo, you need to provide a custom download URL (or file path).
Also, you need to accept the EULA, or DevExpress will not install

```ruby
dev_express "18.2.4" do
  acceptEULA true
  source "https://.../DevExpressComponentsBundle-18.2.4.exe"
end
```

This will download and install DevExpress as a trial version with all products installed.

A full example of all options:

```ruby
dev_express "legacy" do
    version "15.1.8" # must be specified if the version differs from the resource name
    acceptEULA true # this must be passed in order to install
    products ['ASP.NET', 'Windows Forms'] # pass the products to be installed. See https://documentation.devexpress.com/GeneralInformation/15656/Installation/Install-DevExpress-NET-Products/Silent-Install-Mode
    email "me@domain.com" # pass this together with password for a registered copy
    password "superSecret" # pass this together with email for a registered copy
    source "https://.../DevExpressComponents-15.1.8.exe" # pass this if you need to download from a different location than artifactory
    action :install # install is the default
end
```

An example to remove an existing DevExpress:

```ruby
dev_express "15.1.8" do
   action :remove
end
```
