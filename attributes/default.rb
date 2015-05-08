default["container"]["environment_file"]["create"] = true
default["container"]["environment_file"]["owner"] = "root"
default["container"]["environment_file"]["group"] = "root"
default["container"]["environment_file"]["mode"] = "00644"

case node['platform']
  when 'centos'
    default["container"]["environment_file"]["path"] = "/etc/sysconfig"

  when 'debian', 'ubuntu', 'amazon'
    default["container"]["environment_file"]["path"] = "/etc/default"
end

