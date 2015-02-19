require 'chef/resource/lwrp_base'

class Chef
  class Resource
    class StackstormFetch < Chef::Resource::LWRPBase
      self.resource_name = :stackstorm_fetch
      actions :install, :remove, :download
      default_action :install

      attribute :path, kind_of: String
      attribute :packages, kind_of: Array, default: nil
    end
  end
end
