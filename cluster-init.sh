#!/bin/bash
set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Create the local kubernetes cluster (using kind)
kind create cluster --name=home-cluster --config=home-cluster.yaml

### Install the service mesh
helm repo add istio https://istio-release.storage.googleapis.com/charts
helm install istio-base istio/base -n istio-system --create-namespace
helm install istiod istio/istiod -n istio-system --wait
kubectl label ns default istio-injection=enabled --overwrite
kubectl wait pods --for=condition=Ready -l app=istiod -n istio-system

### Install and patch (for kind) istio-gateway

helm install istio-gateway istio/gateway -n istio-system
kubectl patch service istio-gateway -n istio-system --patch-file patches/gateway-svc-patch.yaml

### Optional: Install example apps and gateway
kubectl apply -f example-services.yaml
kubectl apply -f example-gateway.yaml

echo "http://127.0.0.1/appA"
echo "http://127.0.0.1/appB"

### Install monitoring

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm install prometheus prometheus-community/prometheus -n monitoring --create-namespace
# kubectl wait pods --for=condition=Ready -l app=prometheus -n monitoring --timeout=120s
helm install grafana grafana/grafana -n monitoring -f "$SCRIPT_DIR"/grafana-value.yaml
kubectl wait pods --for=condition=Ready -l app.kubernetes.io/instance=grafana -n monitoring --timeout=120s

### Install kiali

helm install kiali-server kiali-server --repo https://kiali.org/helm-charts --set auth.strategy="anonymous" --set external_services.prometheus.url="http://prometheus-server.monitoring" -n istio-system

echo "kubectl port-forward -n istio-system service/kiali 8080:20001"

