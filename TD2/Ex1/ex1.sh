ansible -i inventory.yml node2 -m ping
ansible -i inventory.yml node2 -m command -a "uptime"
ansible -i inventory.yml node2 -m command -a "ls"
ansible -i inventory.yml node2 -m command -a "pwd"
ansible -i inventory.yml node2 -e "var1=Bonjour" -m debug -a 'msg={{ var1 }}'
ansible -i inventory.yml node2 -m copy -a "src=/home/lima.linux/R511/TD2/Ex1/touch dest=/home/lima.linux/R511/TD2/Ex1/touch2"
ansible -i inventory.yml node2 -m fetch -a "src=/home/lima.linux/R511/TD2/Ex1/touch2 dest=/home/lima.linux/R511/TD2/Ex1/tmp/ flat=yes"
ansible -i inventory.yml node2 -m shell -a "ps aux | wc -l"

