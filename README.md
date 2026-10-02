# Platform Engineering & DevSecOps Demo

A compact, production-style platform: three microservices deployed to Kubernetes with GitOps,
a secured CI pipeline, infrastructure as code, and observability with incident drills.

```
GitHub -> GitHub Actions (lint, test, build, Trivy scan, push) -> bumps image tag in Git
                                                                      |
                                                                   ArgoCD (auto-sync, self-heal)
                                                                      |
                                       Kubernetes: users / orders / inventory services
                                                                      |
                                    Prometheus -> Grafana + Alertmanager
```

## What's inside
| Area | Where | Highlights |
|------|-------|-----------|
| Microservices | `microservices/` | Flask, `/healthz`, Prometheus `/metrics`, chaos endpoints, non-root image |
| Kubernetes | `kubernetes/` | Deployment, Service, Ingress, HPA, ConfigMap, RBAC, NetworkPolicies, restricted Pod Security, resource limits |
| GitOps | `argocd/` | Automated sync, prune, self-heal |
| CI/CD | `.github/workflows/ci.yaml` | flake8, pytest, Terraform validate, yamllint, Trivy gate, GHCR push, GitOps tag bump |
| IaC | `terraform/` | GCP VPC, subnet, GKE Autopilot, Artifact Registry (validated in CI, apply optional) |
| Config mgmt | `ansible/` | Installs kube-prometheus-stack + ArgoCD, applies alerts, registers the app |
| Observability | `monitoring/` | ServiceMonitor, alert rules (down, memory, p95 latency) |
| SRE | `docs/incident-response.md` | Four failure drills with runbook template |

## Quick start (local, free)
1. Replace `GITHUB_USER` in `kubernetes/` and `argocd/` with your GitHub username.
2. Push to GitHub, let CI publish images (set package visibility to public).
3. Prerequisites: `docker`, `kind`, `kubectl`, `helm`, `ansible`. Then run `./scripts/local-up.sh`.
4. Port-forward Grafana/ArgoCD (commands printed by the script) and run the drills.

## Roadmap
HashiCorp Vault for secrets, SonarQube quality gate, Loki/ELK log aggregation, OpenShift Routes variant.
