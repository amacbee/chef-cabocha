#
# Cookbook Name:: cabocha
# Recipe:: crf
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

version = node["crf"]["version"]
remote_file "#{Chef::Config[:file_cache_path]}/CRF++-#{version}.tar.gz" do
  source "http://crfpp.googlecode.com/files/CRF++-#{version}.tar.gz"
  mode "0644"
  not_if { ::File.exists?("/usr/local/bin/crf_learn") }
end

bash "build_and_install_CRF++" do
  user "root"
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    tar -zxf CRF++-#{version}.tar.gz
    (cd CRF++-#{version} && ./configure #{node["crf"]["configure_options"]})
    (cd CRF++-#{version} && make && make install)
  EOH
  not_if { ::File.exists?("/usr/local/bin/crf_learn") }
end