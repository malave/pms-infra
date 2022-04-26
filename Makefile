SHELL := /bin/bash # Use bash syntax
colon := ":"
ns := pms

export
init: start_minikube install_addons init_help_repos install_argo install_argo_rollout

start_minikube:
	minikube start --vm=true --cpus 4 --memory 4098 --driver='hyperkit'
	#minikube start --vm=true --cpus 4 --memory 4098
	#minikube start --vm=true --cpus 4 --memory 4098 --nodes 2

install_addons:
	minikube addons enable metrics-server
	minikube addons enable dashboard
	minikube addons enable ingress

init_help_repos:
	#helm repo add grafana https:t//grafana.github.io/helm-charts
	#helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
	#helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
	helm repo update

install_argo:
	kubectl create namespace argocd
	kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

install_argo_rollout:
	kubectl create namespace argo-rollouts
	kubectl apply -n argo-rollouts -f https://github.com/argoproj/argo-rollouts/releases/latest/download/install.yaml

argo_fwd:
	kubectl -n argocd port-forward svc/argocd-server 8080:443

argo_pwd:
	kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d


install_monitoring_stack:
	helm upgrade --install loki grafana/loki-stack  --set grafana.enabled=true,prometheus.enabled=true,prometheus.alertmanager.persistentVolume.enabled=false,prometheus.server.persistentVolume.enabled=false
