- 先检查cpu是否支持虚拟化并且bios是否开启了虚拟化
  - egrep -o '(vmx|svm)' /proc/cpuinfo   运行该命令如果有显示结果就ok

- 安装kvm:  https://www.cyberciti.biz/faq/installing-kvm-on-ubuntu-16-04-lts-server/

- minikube在不同操作系统上的安装,见: https://github.com/kubernetes/minikube/releases

- kubectl的安装: sudo snap install kubectl --classic


- 相关文档:
  - k8s的基本概念 https://kubernetes.io/docs/concepts/
  - https://kubernetes.io/docs/tutorials/kubernetes-basics/
  - https://kubernetes.io/cn/docs/tutorials/object-management-kubectl/object-management/
  - https://kubernetes.io/docs/tutorials/kubernetes-basics/create-cluster/cluster-interactive/
