module StackstormCookbook
  module Helpers
    require 'net/http'

    def st2_current_build
      @st2_current_build ||= begin
        url = [ st2_pkg_baseurl, st2_pkg_version, st2_pkg_type ]
        url << 'current/VERSION.txt'
        Net::HTTP.get(URI( url.map {|s| s.gsub(/\/+$/,'')}.join('/') )).strip
      end
    end

    def st2_pkg_baseurl
      node['stackstorm']['st2_install']['base_url']
    end

    def st2_pkg_version
      node['stackstorm']['version']
    end

    def st2_pkg_type
      @st2_pkg_type ||= case node['platform_family']
          when 'debian'
            'debs'
          when 'fedora', 'rhel'
            'rpms'
          else
            Chef::Log.error("Unsupported platform #{node[:platform]}!")
            raise RuntimeError
      end
    end

    def st2_get_package_url(list)
      build = node['stackstorm']['build'].to_s
      build = st2_current_build if build == 'current'
      url = [ st2_pkg_baseurl, st2_pkg_version, st2_pkg_type, build ]
      url = url.map { |s| s.gsub(/\/+$/, '') }.join('/')
      sf = (st2_pkg_type == 'debs' ? '_amd64.deb' : '.noarch.rpm')
      pf = (st2_pkg_type == 'debs' ? '_' : '-')

      list.map { |name| "#{url}/#{name}#{pf}#{st2_pkg_version}-#{build}#{sf}" }
    end

    def st2_package_cachedir
      ::File.join(node['stackstorm']['home'], 'package_cache')
    end

    def st2_package_cache_path(package_list)
      cache_dir = st2_package_cachedir
      st2_get_package_url(package_list).map do |url|
        ::File.join(cache_dir, ::File.basename(url))
      end
    end

  end
end
