require 'chef/resource/lwrp_base'

class Chef
  class Resource
    class StackstormInstall < Chef::Resource::LWRPBase
      self.resource_name = :stackstorm_install
      actions :install, :remove, :download
      default_action :install

      attribute :packages, kind_of: [String, Symbol, Array], default: nil
    end
  end
end
