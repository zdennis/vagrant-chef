cookbook_file "/etc/ssh/sshd_config" do
  source "sshd_config"
end

service "ssh" do
  supports :status => true, :restart => true, :reload => true
  action [:enable, :start]
  subscribes :reload, resources(:cookbook_file => "/etc/ssh/sshd_config"), :immediately
end

link "/usr/bin/useradd" do
  to "/usr/sbin/useradd"
end

link "/usr/bin/userdel" do
  to "/usr/sbin/userdel"
end

link "/usr/bin/usermod" do
  to "/usr/sbin/usermod"
end

link "/usr/bin/groupmod" do
  to "/usr/sbin/groupmod"
end

link "/usr/bin/groupadd" do
  to "/usr/sbin/groupadd"
end

username = "zdennis"
home_dir = "/home/#{username}"
passwd = "$apr1$F5X2.X1g$4f67855vUSUueGZVW.lCa1"

user username do
  uid "1000"
  password passwd
  supports :manage_home => true
  home home_dir
end

directory "#{home_dir}/.ssh" do
  owner username
  group username
  mode "0700"
end

cookbook_file "#{home_dir}/.ssh/authorized_keys" do
  source "authorized_keys"
  mode "0600"
  owner username
  group username
end

group "sysadmin" do
  members [username]
end
