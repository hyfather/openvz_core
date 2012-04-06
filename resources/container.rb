# This file is part of the 'OpenVZ Core LWRP'
#  
#   'OpenVZ Core LWRP' is free software: you can redistribute it and/or modify
#     it under the terms of the GNU General Public License as published by
#     the Free Software Foundation, either version 3 of the License, or
#     (at your option) any later version.
#  
#     'OpenVZ Core LWRP' is distributed in the hope that it will be useful,
#     but WITHOUT ANY WARRANTY; without even the implied warranty of
#     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#     GNU General Public License for more details.
#  
#     You should have received a copy of the GNU General Public License
#     along with 'OpenVZ Core LWRP'.  If not, see <http://www.gnu.org/licenses/>.
#  
#     For the source code, see -- https://github.com/hyfather/openvz_core
#     Contact me at -- mail@hyfather.com


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
