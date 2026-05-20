# Checklist: Async, Concurrency, Long-Running Work

- [ ] Sync code is used when sufficient
- [ ] Async is justified by I/O/concurrency needs
- [ ] Tokio runtime is not introduced casually
- [ ] Concurrency is bounded
- [ ] Timeouts exist for external operations
- [ ] Retries have limits/backoff
- [ ] Rate limits are respected
- [ ] Cancellation/graceful shutdown is considered
- [ ] Rayon is considered for CPU-bound parallel work
