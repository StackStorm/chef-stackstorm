require 'chef/provider/lwrp_base'
require_relative 'st2_install_helpers'

class Chef
  class Provider
    class StackstormFetch < Chef::Provider::LWRPBase
      include Chef::DSL::IncludeRecipe
      include StackstormCookbook::St2InstallHelpers

      use_inline_resources if defined?(use_inline_resources)

      def whyrun_supported?
        true
      end

      action :download do
        fetch_binaries
      end

      action :install do
        include_recipe('gdebi::default') if pkg_type == 'debs'
        fetch_binaries

        new_resource.packages.each do |pkg_name|
          filename = get_package_basename(pkg_name)
          package "#{new_resource.recipe_name} :install package #{pkg_name}" do
            source "#{new_resource.path}/#{filename}"
            provider package_provider
            action :install

            notifies :create, 'file[:fixate StackStorm build version]'
          end
        end

        # fixate package build
        file ":fixate StackStorm build version" do
          path "#{new_resource.path}/build_number"
          content(pkg_build + "\n")
          action :nothing
        end
      end

      action :remove do
        packages = Array.new(new_resource.packages)

        # handle different name for debian package
        pkg_type == 'debs' and packages.delete('st2client') and
            packages.push('python-st2client')

        packages.each do |pkg_name|
          package "#{new_resource.recipe_name} :remove package #{pkg_name}" do
            package_name pkg_name
            action :remove
          end
        end
      end

      def package_list
        @package_list ||= Array(new_resource.packages).map {|s| s.to_s}
      end

      def fetch_binaries
        directory "#{new_resource.recipe_name} :create package cache directory #{new_resource.path}"  do
          path new_resource.path
          owner 'root'
          group 'root'
          mode '0755'
          action :create
        end

        new_resource.packages.each do |pkg_name|
          url = get_package_url(pkg_name)
          remote_file "#{new_resource.recipe_name} :fetching package from #{url}" do
            path ::File.join(new_resource.path, ::File.basename(url))
            source url
            action :create_if_missing
          end
        end
      end

    end
  end
end
