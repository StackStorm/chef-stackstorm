require 'chefspec'
require 'chefspec/berkshelf'
require 'pry'

at_exit { ChefSpec::Coverage.report! }

###
# StackstormCookbook module
module StackstormCookbook
  ###
  # StackstormCookbook Spec helpers
  module SpecHelper
    def global_stubs_include_recipe
      # Don't worry about external cookbook dependencies
      allow_any_instance_of(Chef::Cookbook::Metadata).to receive(:depends)

      # Test each recipe in isolation, regardless of includes
      @included_recipes = []

      allow_any_instance_of(Chef::RunContext).to receive(:loaded_recipe?).and_return(false)
      allow_any_instance_of(Chef::Recipe).to receive(:include_recipe) do |i|
        allow_any_instance_of(Chef::RunContext).to receive(:loaded_recipe?).and_return(true)
        @included_recipes << i
      end
      allow_any_instance_of(Chef::RunContext).to receive(:loaded_recipe).and_return(@included_recipes)
    end
  end
end

RSpec.configure do |config|
  config.platform = 'redhat'
  config.version = '7.1'
  config.include StackstormCookbook::SpecHelper
end
