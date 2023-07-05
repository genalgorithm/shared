#!/bin/bash


set -eu

#create namespace
kubectl create -f kube-logging.yaml

#verify the created namespace
kubectl get namespaces

#Creating the Elasticsearch StatefulSet
kubectl create -f elasticsearch_svc.yaml

#verify sevices on logging namespace
kubectl get services --namespace=kube-logging

#create statefulsets
kubectl create -f elasticsearch_statefulset.yaml

#check pod status for elasticsearch
kubectl rollout status sts/es-cluster --namespace=kube-logging

#verify using port forward
#kubectl port-forward es-cluster-0 9200:9200 --namespace=kube-logging

#curl http://localhost:9200/_cluster/state?pretty

#Creating the Kibana Deployment and Service
kubectl create -f kibana.yaml

#check pod status for kibana
kubectl rollout status deployment/kibana --namespace=kube-logging

#verify using port forward
#kubectl port-forward kibana-74ff49cc95-j92j7 5601:5601 --namespace=kube-logging

#verify if kibana is accessible
#http://localhost:5601

#Creating the Fluentd DaemonSet

kubectl create -f fluentd.yaml

#check fluentd daemonset
kubectl get ds --namespace=kube-logging

#(Optional) — Testing Container Logging
#kubectl create -f counter.yaml

snap install ngrok
#ngrok config add-authtoken {}
#ngrok http 9000