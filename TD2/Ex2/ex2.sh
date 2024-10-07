ansible -i inventory.yml all -m debug -a 'msg={{ var1 }}'
ansible-inventory-grapher -i inventory.yml all | dot -Tpng -o inventory_graph.png
open inventory_graph.png
