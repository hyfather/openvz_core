This chef cookbook was written to reliably create and converge system configurations for OpenVZ containers.  
Leveraging Chef Server's ReST API to manage OpenVZ containers can help in setting up a compute cloud for your own IaaS.  
Of course, such a compute cloud has limitations of affording only OS-Virtualized GNU/Linux hosts.  

## Using with an open-source Chef Server and Chef Client
### Recommended

This method relies on Data Bags for storing all contianer metadata.  
To create new containers, new data bags are created and uploaded to the Chef Server using its API.
To modify existing containers, the data bags are edited, once again using the Chef Server's API.
Currently, there is no automation for stopping and destroying containers.

To start off, you would need a data bag called `openvz_ctids` to store information regarding all the containers in your eco-system.

From the root of your Chef respository, create a data bag item called `list` --  

````
$ mkdir -p data_bags/openvz_ctids  
$ cat > data_bags/openvz_ctids/list.json  
{
  "id" : "list",
  "001" : "",
  "002" : ""
}^D
$ knife data bag from file openvz_ctids data_bags/openvz_ctids/list.json 
````

This means that we are configuring our system to allow a maximum of 2 containers.  
They will have their `CTID` as 001 and 002.
You can create as many entries as your hardware can support in the list data bag item.

Next, to create the containers themselves, we need a `openvz_containers` data bag.
Once this is created, upload a data bag item like this to fire off a new container --

````
{
  "id"                  : "web_server",
  "description"         : "stock installation of httpd",
  "billing"             : "SOME_TEAM_NAME",
  "ostemplate"          : "centos-6-x86_64",

  "instance_type"       : "medium"
}
````

Once this data_bag is uploaded, a new container with these details will be created on the next chef-run.
The included from_databags recipe is the current reference implementation of this method.



## Using only the LWRP

If you want to use only the Lightweight Resource Provider (LWRP) that comes with this cookbook, this is how your recipe should look --

````
container "web_server" do
  action        [:create, :start]

  description   "A server that speaks HTTP"
  billing       "SOME_PROJECT" #project billing code
  ostemplate    "centos-6-x86_64" 

  cpulimit      50        # Is a hard limit on % utilization of 1 CPU core. E.g. on a 4 core server, 100% means 1 CPU core reserved.
  cpus          1         # CPUs 
  memory        2048      # Represented in MiB
  diskspace     5         # Represented in GiB
  swap          512       # Represented in MiB
  diskinodes    2000000   # Actual number

  nameserver    "10.10.100.0"             # Will go into /etc/resolv.conf. Can be a whitespace separated list.
  searchdomain  "ns.my_company.com"   # Will go into /etc/resolv.conf. Can be a whitespace separated list.
end
````


## Using with Chef Solo

Setup the `/etc/chef/solo.rb` with the data_bag path, log_levels etc.
Create the data_bags in the correct path.

Run the included solo runlist like this --
````
$ chef-solo -j cookbooks/openvz/openvz.json
````
