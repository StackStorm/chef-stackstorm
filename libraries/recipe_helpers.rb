module StackstormCookbook
  module RecipeHelpers

    def st2_service_config
      Mash.new({
        st2api: {
          service_bin: "#{st2_bin_prefix}/st2api"
        },
        st2sensorcontainer: {
          service_bin: "#{st2_bin_prefix}/sensor_container"
        },
        st2history: {
          service_bin: "#{st2_bin_prefix}/history"
        },
        st2rulesengine: {
          service_bin: "#{st2_bin_prefix}/rules_engine"
        },
        st2actionrunner: {
          service_bin: "#{st2_bin_prefix}/actionrunner",
          runas_user:  'root',
          runas_group: 'root'
        }
      })
    end

    def st2_bin_prefix
      @st2_bin_prefix ||= begin
        case node['stackstorm']['install_method'].to_sym
        when :system_wide
          '/usr/bin'
        else
          Chef::Log.error("install_method " <<
            "#{node['stackstorm']['install_method']} is not supported!")
          raise ArgumentError
        end
      end
    end

    # Service provider mapping
    def service_provider
      @service_provider ||= begin
        supported = [
          :upstart, :debian, :systemd
        ]
        exception = NotImplementedError.new("platform #{node[:platform]} " <<
                        "#{node[:platform_version]} not supported")

        # --- overrides
        if node.platform == 'ubuntu'
          :upstart
        elsif node.platform_family?('rhel')
          node.platform_version.to_f < 7 ? raise(exception) : :systemd
        elsif node.platform == 'fedora'
          node.platform_version.to_f < 15 ? raise(exception) : :systemd

        # --- fallbacks
        elsif supported.include? default_service_provider
          default_service_provider
        elsif node.platform_family? 'debian'
          :debian
        else
          raise(exception)
        end
      end
    end

    def default_service_provider
      @default_service_provider ||= Chef::Platform.find_provider(node.platform,
                            node.platform_version, :service).name.split('::').
                              last.downcase.to_sym
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

    def register_content(*args)
      content = args.map {|s| "--register-#{s}"}.join(' ')
      python_pack = self.python_pack
      conf_path = node['stackstorm']['conf_path']

      if !content.empty?
        execute "#{recipe_name} register st2 content with: #{content}" do
          command("python #{python_pack}/st2common/bin/registercontent.py " <<
                                      "#{content} --config-file #{conf_path}")
        end
      end
    end

    def python_pack
      # get python version, ex. 2.7 for 2.7.6
      pv = node['languages']['python']['version'].to_f
      case node.platform_family
      when 'debian'
        "/usr/lib/python#{pv}/dist-packages"
      when 'rhel', 'fedora'
        "/usr/lib/python#{pv}/site-packages"
      end
    end

  end
end
