module StackstormCookbook
  module RecipeHelpers
    # Retrieve list of enabled components, and populate attribute.
    def apply_components
      at = node['stackstorm']['roles']
      components = (%w(st2common) + node['stackstorm']['components']).uniq

      # mind order, services are brought acorrding to the given sequence
      components += %w(st2common st2api st2reactor st2auth) if at.include?('controller')
      components += %w(st2common st2actions) if at.include?('worker')
      components += %w(st2common st2client) if at.include?('client')

      node.default['stackstorm']['components'] = components.uniq
    end
  end
end
