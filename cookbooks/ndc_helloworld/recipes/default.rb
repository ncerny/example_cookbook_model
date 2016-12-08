#
# Cookbook Name:: ndc_helloworld
# Recipe:: default
#
# Copyright 2016 Nathan Cerny
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

include_recipe 'acme_core'

httpd_service 'default' do
  action [:create, :start]
end

directory '/var/www/html' do
  action :create
  recursive true
end

file '/var/www/html/index.html' do
  content <<-EOS
    <h1> Hello World!</h1>
    This is version: #{run_context.cookbook_collection[cookbook_name].metadata.version}
    EOS
  notifies :restart, 'httpd_service[default]'
end

httpd_config 'hello_world' do
  source 'hello_world.cnf.erb'
  notifies :restart, 'httpd_service[default]'
  action :create
end
