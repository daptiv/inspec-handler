#
# Cookbook:: inspec-handler
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

inspec_handler_setup 'test' do
  cookbook_names ['daptiv_api']
end
