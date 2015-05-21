actions :add, :remove, :start, :restart, :stop, :enable, :disable, :update_image
default_action :add if defined?(default_action)

attribute :name, :kind_of => String, :name_attribute => true

attribute :depend, :kind_of => Array, :required => false

attribute :environment, :kind_of => Array, :required => false, :default => []
attribute :ports, :kind_of => String, :required => false, :default => ""
attribute :link, :kind_of => String, :required => false, :default => ""
attribute :image, :kind_of => String, :required => false, :default => ""
attribute :volumes, :kind_of => String, :required => false, :default => ""
attribute :extra, :kind_of => String, :required => false, :default => ""
attribute :command, :kind_of => String, :required => false, :default => ""
attribute :env_deploypath, :kind_of => String, :required => false
