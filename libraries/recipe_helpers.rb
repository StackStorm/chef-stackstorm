module StackstormCookbook
  module RecipeHelpers

    def stackstorm_service(service_name, &block)
      init_path = service_init_path(service_name)
      service_provider = self.service_provider
      update_actions = Array(node['stackstorm']['on_config_update'])

      template "#{recipe_name} :create init template for #{service_name}" do
        path init_path
        source "#{service_provider}/st2-init.erb"
        cookbook 'stackstorm'
        action :create
        case service_provider
        when :debian, :redhat
          mode '0755'
        end
      end.instance_eval(&block)

      service "#{recipe_name} enable and start StackStorm service #{service_name}" do
        service_name service_name
        provider Chef::Provider::Service.const_get(service_provider.to_s.capitalize)
        action [ :enable, :start ]

        # Handle update actions for services
        if (service_name !~ /^st2actionrunner-/)
          update_actions.each { |action|
            subscribes action, 'template[:create StackStorm configuration]'
          }
        end
      end
    end

    # Service provider mapping
    def service_provider
      @service_provider ||= begin
        cookbook_supports = [:upstart, :debian, :systemd, :redhat]
        platform_supports = Chef::Platform::ServiceHelpers.service_resource_providers
        avail = cookbook_supports.select { |sv| platform_supports.include? sv }

        if avail.empty?
            NotImplementedError.new("platform #{node[:platform]} " \
                                    "#{node[:platform_version]} not supported")
        end

        case node.platform_family
        when 'debian'
          avail.include?(:upstart) ? :upstart : :debian
        when 'rhel', 'fedora'
          avail.include?(:systemd) ? :systemd : :redhat
        else
          avail.first
        end
      end
    end

    def service_init_path(svc_name)
      case service_provider
      when :upstart
        "/etc/init/#{svc_name}.conf"
      when :systemd
        "/usr/lib/systemd/system/#{svc_name}.service"
      when :debian
        "/etc/init.d/#{svc_name}"
      end
    end

    def register_content(opt_list)
      content = Array(opt_list).map {|s| "--register-#{s}"}.join(' ')
      conf_path = node['stackstorm']['conf_path']

      if !content.empty?
        execute "#{recipe_name} register st2 content with: #{content}" do
          command("st2-register-content " << "#{content} --config-file #{conf_path}")
        end
      end
    end

    # Retrive list of enabled components, and populate attribute.
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

    def _service_providers
      Chef::Platform::ServiceHelpers.service_resource_providers
    end

  end
end
