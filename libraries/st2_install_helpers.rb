module StackstormCookbook
  module St2InstallHelpers
    require 'net/http'

    def current_build
      url = [ pkg_baseurl, pkg_version, pkg_type ]
      url << 'current/VERSION.txt'
      Net::HTTP.get(URI( url.map {|s| s.gsub(/\/+$/,'')}.join('/') )).strip
    end

    def pkg_baseurl
      node['stackstorm']['install_stackstorm']['base_url']
    end

    def pkg_version
      node['stackstorm']['install_stackstorm']['version']
    end

    def pkg_build
      @pkg_build ||= begin
        already_fixed = ::IO.read("#{new_resource.path}/build_number").strip rescue nil
        if already_fixed
          already_fixed
        else
          b = node['stackstorm']['install_stackstorm']['build'].to_s
          b == 'current' ? current_build : b
        end
      end
    end

    def pkg_type
      @pkg_type ||= case node['platform_family']
          when 'debian'
            'debs'
          when 'fedora', 'rhel'
            'rpms'
          else
            Chef::Log.error("Unsupported platform #{node[:platform]}!")
            raise RuntimeError.new
      end
    end

    def get_package_url(package_name)
      url = [ pkg_baseurl, pkg_version, pkg_type, pkg_build ]
      url = url.map { |s| s.gsub(/\/+$/, '') }.join('/')

      "#{url}/#{get_package_basename(package_name)}"
    end

    def get_package_basename(package_name)
      sf = (pkg_type == 'debs' ? '_amd64.deb' : '.noarch.rpm')
      pf = (pkg_type == 'debs' ? '_' : '-')

      "#{package_name}#{pf}#{pkg_version}-#{pkg_build}#{sf}"
    end

    def package_provider
      if pkg_type == 'debs'
        Chef::Provider::Package::Gdebi
      elsif pkg_type == 'rpms'
        Chef::Provider::Package::Yum
      end
    end

    def package_cachedir
      ::File.join(node['stackstorm']['home'], 'package_cache')
    end

    def package_cache_path(package_list)
      cache_dir = package_cachedir
      get_package_url(package_list).map do |url|
        ::File.join(cache_dir, ::File.basename(url))
      end
    end

  end
end
