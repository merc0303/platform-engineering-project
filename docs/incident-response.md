# Incident drills

Each drill: trigger it, record what you saw, and fill in the timeline. Add screenshots to `docs/img/`.

| # | Drill | Trigger | Expected signal | Fix |
|---|-------|---------|-----------------|-----|
| 1 | Service down | `kubectl -n shop scale deploy/orders-service --replicas=0` | `ServiceDown` fires in Alertmanager | ArgoCD `selfHeal` restores replicas |
| 2 | Memory leak | `curl <svc>/chaos/leak` in a loop | `PodMemoryNearLimit`, then OOMKilled + restart | Raise limit or fix leak; document RCA |
| 3 | High traffic | `curl "<svc>/chaos/cpu?s=30"` from several shells, or `hey`/`k6` | HPA scales 2 -> up to 6 pods | Tune HPA target / requests |
| 4 | Bad deployment | Push a commit that breaks `/healthz` | Readiness fails, rollout stalls, old pods keep serving | `git revert` -> ArgoCD syncs back (or `argocd app rollback shop`) |

## Template
- **Detection:** which alert / dashboard, time to detect
- **Impact:** what users saw
- **Root cause:**
- **Resolution:**
- **Follow-ups:**
