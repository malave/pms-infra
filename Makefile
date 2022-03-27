SHELL := /bin/bash # Use bash syntax
colon := ":"
ns := pms

export
init: start_minikube install_addons init_help_repos

start_minikube:
	minikube start --vm=true --cpus 4 --memory 4098
	#minikube start --vm=true --cpus 4 --memory 4098 --nodes 2

install_addons:
	minikube addons enable metrics-server
	minikube addons enable dashboard
	minikube addons enable ingress

init_help_repos:
	helm repo add grafana https:t//grafana.github.io/helm-charts
	#helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
	#helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
	helm repo update

install_monitoring_stack:
	helm upgrade --install loki grafana/loki-stack  --set grafana.enabled=true,prometheus.enabled=true,prometheus.alertmanager.persistentVolume.enabled=false,prometheus.server.persistentVolume.enabled=false
