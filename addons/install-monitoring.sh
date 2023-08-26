#!/bin/bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

brew install helm
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm install prometheus prometheus-community/prometheus -n monitoring --create-namespace
kubectl wait pods --for=condition=Ready -l app=prometheus -n monitoring --timeout=120s
helm install grafana grafana/grafana -n monitoring -f "$SCRIPT_DIR"/grafana-value.yaml
kubectl wait pods --for=condition=Ready -l app.kubernetes.io/instance=grafana -n monitoring --timeout=120s

