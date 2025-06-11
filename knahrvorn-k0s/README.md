# Run the playbook
ansible-playbook playbook.yml -i inventory
ansible-playbook playbook.yml -i inventory --tags common,k0s

#### Check nodes
```
pmh@knahrvorn-k0s-001:~$ sudo k0s kubectl get nodes
NAME                STATUS   ROLES           AGE     VERSION
knahrvorn-k0s-001   Ready    control-plane   4m44s   v1.33.1+k0s
knahrvorn-k0s-002   Ready    <none>          4m31s   v1.33.1+k0s
knahrvorn-k0s-003   Ready    <none>          4m31s   v1.33.1+k0s
```

https://www.virtualizationhowto.com/2023/07/k0s-vs-k3s-battle-of-the-tiny-kubernetes-distros/  
https://k0sproject.io/
