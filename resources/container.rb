actions :create, :start, :nothing

only_letters_numbers_and_underscores = /^[a-zA-Z_\d]+$/

attribute :ctid, :kind_of => String
attribute :name, :regex => only_letters_numbers_and_underscores
attribute :description, :kind_of => String
attribute :billing, :kind_of => String
attribute :ostemplate, :kind_of => String

attribute :instance_type, :kind_of => String

attribute :cpulimit, :kind_of => Integer
attribute :cpus, :kind_of => Integer
attribute :memory, :kind_of => Integer
attribute :diskspace, :kind_of => Integer
attribute :swap, :kind_of => Integer
attribute :diskinodes, :kind_of => Integer

attribute :nameserver, :kind_of => String
attribute :searchdomain, :kind_of => String
attribute :userpasswd, :kind_of => String
