[k3s_server]
%{ for node in masters ~}
${node.name} ansible_host=${node.ip}
%{ endfor ~}


[k3s_workers]
%{ for node in workers ~}
${node.name} ansible_host=${node.ip}
%{ endfor ~}


[k3s_cluster:children]
k3s_server
k3s_workers

[k3s_cluster:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=~/.ssh/jet
