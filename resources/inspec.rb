# To learn more about Custom Resources, see https://docs.chef.io/custom_resources.html

resource_name :inspec_handler_setup

property :cookbook_names, Array, required: true

action :run do
  handler_path = ::File.join(Chef::Config[:file_cache_path], 'handlers')

  inspec_path = value_for_platform_family(
    'windows' => 'C:/opscode/chef/embedded/bin/',
    'default' => '/opt/chef/embedded/bin/'
  )

  profile_paths = new_resource.cookbook_names.collect do |cookbook_name|
    ::File.join(
      Chef::Config[:file_cache_path],
      "cookbooks/#{cookbook_name}/files/#{cookbook_name}_tests-0.1.0.tar.gz",
    ) 
  end

  # execute 'do-the-thing' do
    # command "#{::File.join(inspec_path, 'inspec')} exec #{profile_paths}"
    # returns [0, 101]
    # action :nothing
    # delayed_action :run
  # end

  directory handler_path

  cookbook_file "#{handler_path}/inspec_handler.rb" do
    source 'inspec_handler.rb'
    action :create
  end

  chef_handler 'InspecHandler::Report' do
    source "#{handler_path}/inspec_handler.rb"
    arguments :inspec_path => inspec_path, :profile_paths => profile_paths
    supports :report => true
    action :enable
  end
end
