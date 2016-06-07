module StackstormCookbook
  module RecipeHelpers

    # Retrieve list of enabled components, and populate attribute.
    def apply_components
      at = node['stackstorm']['roles']
      components = (%w(st2common) + node['stackstorm']['components']).uniq

      # mind order, services are brought acorrding to the given sequence
      at.include?('controller') and
            components += %w(st2common st2api st2reactor st2auth)
      at.include?('worker') and
            components += %w(st2common st2actions)
      at.include?('client') and
            components += %w(st2common st2client)

      node.default['stackstorm']['components'] = components.uniq
    end

    private
  end
end
