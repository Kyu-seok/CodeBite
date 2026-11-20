# Monitoring

How metrics are scraped and shown locally, and what each metric counts. Open it to add, rename or read a metric.

## Prometheus + Grafana
- **Prometheus**: Scrapes metrics from backend (`:8080/actuator/prometheus`) and worker (`:8081/actuator/prometheus`) every 15s
- **Grafana**: `http://localhost:3001` (admin/admin) — auto-provisioned with Prometheus datasource and CodeBite Overview dashboard
- **Config**: `infra/prometheus/` (scrape configs), `infra/grafana/provisioning/` (datasource + dashboards)

## Custom Metrics
| Metric | Type | Source | Description |
|--------|------|--------|-------------|
| `codebite.submissions.created` | Counter | Backend | Total submissions created |
| `codebite.submissions.completed` | Counter | Worker | Submissions completed (tags: `status`, `language`) |
| `codebite.submissions.processing.duration` | Timer | Worker | Time to process a submission through Judge0 |
| `codebite.solution.commits` | Counter | Backend | Solution Commits by final outcome after retries (tag: `outcome` = `committed`, `failed`, or `broken` when the installation or repository is gone, which is never retried). An Import counts each commit in its batch |
| `codebite.tutorial.milestones` | Counter | Backend | Tutorial milestones reached, each reported once per run of the Tutorial by the browser (tag: `milestone` = `started`, `ran`, `submitted`, `accepted`, `skipped`); anonymous |

## Built-in Metrics (via Actuator)
- `http_server_requests_seconds` — HTTP request rate, latency, status codes per endpoint
- `jvm_memory_used_bytes` — JVM heap/non-heap memory
- `hikaricp_connections_*` — Database connection pool (active, idle, pending)
- `kafka_consumer_fetch_manager_records_lag` — Kafka consumer lag per partition
