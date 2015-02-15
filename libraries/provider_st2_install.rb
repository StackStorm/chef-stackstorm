require 'chef/provider/lwrp_base'
require_relative 'helpers'

class Chef
  class Provider
    class StackstormInstall < Chef::Provider::LWRPBase
      include Chef::DSL::IncludeRecipe
      include StackstormCookbook::Helpers

      use_inline_resources if defined?(use_inline_resources)

      def whyrun_supported?
        true
      end

      action :download do
        fetch_binaries
      end

      action :install do
        fetch_binaries

        st2_package_cache_path(package_list).zip(package_list) do |path, pkg_name|
          package "#{new_resource.name} :install package #{pkg_name}" do
            source path
            provider package_provider
            action :install
          end
        end
      end

      action :remove do
        packages = package_list.dup
        if st2_pkg_type == 'debs'
          # rename package for deb platform
          packages.delete('st2client') and packages.push('python-st2client')
        end
        packages.each do |pkg_name|
          package "#{new_resource.name} :remove package #{pkg_name}" do
            package_name pkg_name
            action :remove
          end
        end
      end

      def package_provider
        if st2_pkg_type == 'debs'
          include_recipe('gdebi::default')
          Chef::Provider::Package::Gdebi
        elsif st2_pkg_type == 'rpms'
          Chef::Provider::Package::Yum
        end
      end

      def package_list
        @package_list ||= Array(new_resource.packages).map {|s| s.to_s}
      end

      def fetch_binaries
        cache_dir = st2_package_cachedir

        directory "#{new_resource.name} :create package cache directory #{cache_dir}"  do
          path cache_dir
          owner 'root'
          group 'root'
          mode '0755'
          action :create
        end

        st2_get_package_url(package_list).each do |url|
          remote_file "#{new_resource.name} downloading package from #{url}" do
            path ::File.join(cache_dir, ::File.basename(url))
            source url
            action :create
          end
        end
      end

    end
  end
end
