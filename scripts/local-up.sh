#!/usr/bin/env bash
# Free, local demo: kind cluster + monitoring + ArgoCD via Ansible.
set -euo pipefail
kind create cluster --name shop || true
ansible-galaxy collection install kubernetes.core
ansible-playbook ansible/install_monitoring.yml
echo "Grafana:  kubectl -n monitoring port-forward svc/kube-prometheus-stack-grafana 3000:80"
echo "ArgoCD:   kubectl -n argocd port-forward svc/argocd-server 8080:443"
