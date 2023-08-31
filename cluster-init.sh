#!/bin/bash
set -e

# Create the local kubernetes cluster (using kind)
kind create cluster --name=home-cluster --config=home-cluster.yaml

### Install the service mesh
helm repo add istio https://istio-release.storage.googleapis.com/charts
helm install istio-base istio/base -n istio-system --create-namespace
helm install istiod istio/istiod -n istio-system --wait

kubectl label ns default istio-injection=enabled --overwrite
kubectl wait pods --for=condition=Ready -l app=istiod -n istio-system

### Install jaeger
#kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.18/samples/addons/jaeger.yaml
kubectl apply -f ./services/jaeger.yaml

### Install and patch (for kind) istio-gateway

helm install istio-ingressgateway istio/gateway -n istio-system
kubectl patch service/istio-ingressgateway -n istio-system --patch-file patches/gateway-svc-patch.yaml

helm install istio-egressgateway istio/gateway -n istio-system

### Install prometheus
#kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.18/samples/addons/prometheus.yaml
kubectl apply -f ./services/prometheus.yaml

### Install grafana
#kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.18/samples/addons/grafana.yaml
kubectl apply -f ./services/grafana.yaml

### Install kiali

#kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.18/samples/addons/kiali.yaml
kubectl apply -f ./services/kiali.yaml

### Install cert-manager
#kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.12.0/cert-manager.yaml
kubectl apply -f ./services/cert-manager.yaml

### Ingresses for the installed apps

### http://grafana.127.0.0.1.nip.io/
kubectl apply -f ./apps/grafana/gateway.yaml

### http://kiali.127.0.0.1.nip.io/
kubectl apply -f ./apps/kiali-gateway/gateway.yaml


### Install Keycloak and ingress http://keycloak.127.0.0.1.nip.io/
kubectl apply -f ./addons/keycloak/keycloak.yaml
kubectl apply -f ./addons/keycloak/gateway.yaml


### Building the simple docker app (and upload it into the kind cluster)
#docker build -t simple-app -f apps/src/simple-app-poc/Dockerfile apps/src/simple-app-poc


