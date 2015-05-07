def whyrun_supported?
  true
end

use_inline_resources

action :add do
  case node['platform']
    # UBUNTU 14.04
    when 'debian', 'ubuntu'

    systemd_upstart "#{new_resource.name}.conf" do
      if new_resource.depend
        starton "started #{new_resource.depend}"
        stopon "stopping #{new_resource.depend}"
      end
      execstartpre "exec sh -c \"/usr/bin/docker rm -f #{new_resource.name} || true\""
      execstart <<-EOF
        /usr/bin/docker run --name #{new_resource.name} --rm \
          --env-file=#{node["container"]["environment_file"]["path"]}/#{new_resource.name} #{new_resource.extra} \
          #{new_resource.volumes} \
          #{new_resource.ports} \
          #{new_resource.link} \
          #{new_resource.image} \
          #{new_resource.command}
      EOF
      execstop "exec sh -c \"/usr/bin/docker kill #{new_resource.name}\""
      restart 'always'
      execstoppost "exec sleep 5"
    end

  when 'centos'
    if node['platform_version'].to_f > 6.9

      execute 'systemctl-daemon-reload' do
        command '/bin/systemctl --system daemon-reload'
        action :nothing
      end

      systemd_unit "#{new_resource.name}.service" do
        after "#{new_resource.depend}"
        requires "#{new_resource.depend}"
        execstartpre "-/usr/bin/docker rm -f #{new_resource.name}"
        execstart <<-EOF
          /usr/bin/docker run --name #{new_resource.name} --rm \
            --env-file=#{node["container"]["environment_file"]["path"]}/#{new_resource.name} #{new_resource.extra} \
            #{new_resource.volumes} \
            #{new_resource.ports} \
            #{new_resource.link} \
            #{new_resource.image} \
            #{new_resource.command}
        EOF
        execstop "-/usr/bin/docker kill #{new_resource.name}"
        restart 'always'
        timeoutstartsec '0'
        notifies :run, 'execute[systemctl-daemon-reload]', :delayed
      end
    else
      fail "Container package for Centos `#{node['platform_version']} is not supported.`"
    end
  end

  template new_resource.name do
    if new_resource.env_deploypath
      path "#{new_resource.env_deploypath}/#{new_resource.name}"
    else
      path "#{node["container"]["environment_file"]["path"]}/#{new_resource.name}"
    end
    source "envfile.erb"
    owner node["container"]["environment_file"]["owner"]
    group node["container"]["environment_file"]["group"]
    mode node["container"]["environment_file"]["mode"]
    variables(
      :name => new_resource.name,
      :environment => new_resource.environment
    )
    cookbook "container"
    action :create
  end
end

action :remove do

  if new_resource.env_deploypath
    path = "#{new_resource.env_deploypath}/#{new_resource.name}"
  else
    path = "#{node["container"]["environment_file"]["path"]}/#{new_resource.name}"
  end
  file path do
    action :delete
  end

  case node['platform']
    # UBUNTU 14.04
    when 'debian', 'ubuntu'
      systemd_upstart "#{new_resource.name}" do
        action :remove
      end

    when 'centos'
      if node['platform_version'].to_f > 6.9
        systemd_unit "#{new_resource.name}.service" do
          action :remove
        end

      else
        fail "Container package for Centos `#{node['platform_version']} is not supported.`"
      end
  end

end

action :start do
  case node['platform']
    # UBUNTU 14.04
    when 'debian', 'ubuntu'
      systemd_upstart "#{new_resource.name}" do
        action :start
      end

    when 'centos'
      if node['platform_version'].to_f > 6.9
        systemd_unit "#{new_resource.name}.service" do
          action :start
        end

      else
        fail "Container package for Centos `#{node['platform_version']} is not supported.`"
      end
  end
end

action :restart do
  case node['platform']
    # UBUNTU 14.04
    when 'debian', 'ubuntu'
      systemd_upstart "#{new_resource.name}" do
        action :restart
      end

    when 'centos'
      if node['platform_version'].to_f > 6.9
        systemd_unit "#{new_resource.name}.service" do
          action :restart
        end

      else
        fail "Container package for Centos `#{node['platform_version']} is not supported.`"
      end
  end
end

action :stop do
  case node['platform']
    # UBUNTU 14.04
    when 'debian', 'ubuntu'
      systemd_upstart "#{new_resource.name}.conf" do
        action :stop
      end

    when 'centos'
      if node['platform_version'].to_f > 6.9
        systemd_unit "#{new_resource.name}.service" do
          action :stop
        end

      else
        fail "Container package for Centos `#{node['platform_version']} is not supported.`"
      end
  end
end
