#
# Cookbook Name:: cabocha
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "cabocha::crf"
include_recipe "cabocha::mecab"
include_recipe "cabocha::ipadic"

version = node["cabocha"]["version"]
remote_file "#{Chef::Config[:file_cache_path]}/cabocha-#{version}.tar.bz2" do
  not_if "which cabocha"
  source "http://cabocha.googlecode.com/files/cabocha-#{version}.tar.bz2"
  mode "0644"
end

bash "Build and Install CaboCha" do
  not_if "which cabocha"
  user "root"
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    tar -jxf cabocha-#{version}.tar.bz2
    (cd cabocha-#{version} && ./configure #{node["cabocha"]["configure_options"]})
    (cd cabocha-#{version} && make && make install)
  EOH
  not_if { ::File.exists?("/usr/local/bin/cabocha") }
end
