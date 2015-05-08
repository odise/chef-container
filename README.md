# container-cookbook

Convenience layer to encapsulate systemd and Upstart config files for Docker containers. Depending on the Platform for one or the other will be used to start containers.

Docker environment definitions will be stored in `env-files`.

## Supported Platforms

Ubuntu 14.04, Amazon 2014.09, CentOS 7.1

## Attributes

see `attributes/default.rb` file

## Usage

The cookbook implements `unit` LWPR to define container units. `systemd-cookbook::unit` and `systemd-cookbook::upstart` LWPRs will be used depending on the platform.

```
container_unit 'logspout' do
    depend ["docker"]
    volumes "-v /var/run/docker.sock:/tmp/docker.sock"
    ports "--publish=80:8000"
    image "gliderlabs/logspout"
end
container_unit 'logspout' do
	action [:add, :remove, :start, :stop, :restart]
end
```

## License and Authors

Author:: Jan Nabbefeld
