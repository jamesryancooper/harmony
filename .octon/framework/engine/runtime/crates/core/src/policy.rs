use crate::config::RuntimeConfig;
use crate::errors::{ErrorCode, KernelError, Result};
use crate::registry::ServiceDescriptor;
use serde_json::json;
use std::collections::BTreeSet;

#[derive(Debug, Clone)]
pub enum PolicyDecision {
    Allow { granted: Vec<String> },
    Deny { error: KernelError },
}

pub struct PolicyEngine {
    cfg: RuntimeConfig,
}

impl PolicyEngine {
    pub fn new(cfg: RuntimeConfig) -> Self {
        Self { cfg }
    }

    pub fn decide(
        &self,
        service: &ServiceDescriptor,
        requested_capabilities: &[String],
    ) -> PolicyDecision {
        // Deny-by-default.
        let service_id = service.key.id();

        // Allowed capabilities according to policy config.
        let mut allowed: BTreeSet<String> = BTreeSet::new();
        allowed.extend(self.cfg.policy.default_allow.iter().cloned());

        if let Some(cat_allow) = self.cfg.policy.category_allow.get(&service.key.category) {
            allowed.extend(cat_allow.iter().cloned());
        }

        if let Some(svc_allow) = self.cfg.policy.service_allow.get(&service_id) {
            allowed.extend(svc_allow.iter().cloned());
        }

        let declared = service
            .manifest
            .capabilities_required
            .iter()
            .cloned()
            .collect::<BTreeSet<_>>();

        let requested = requested_capabilities
            .iter()
            .cloned()
            .collect::<BTreeSet<_>>();

        let mut undeclared = Vec::new();
        for cap in &requested {
            if !declared.contains(cap) {
                undeclared.push(cap.clone());
            }
        }

        if !undeclared.is_empty() {
            return PolicyDecision::Deny {
                error: KernelError::new(
                    ErrorCode::CapabilityDenied,
                    format!("requested capabilities exceed service manifest for {service_id}"),
                )
                .with_details(json!({
                    "service": service_id,
                    "undeclared": undeclared,
                })),
            };
        }

        // Requested capabilities must be allowed by policy.
        let mut missing = Vec::new();
        for cap in &requested {
            if !allowed.contains(cap) {
                missing.push(cap.clone());
            }
        }

        if !missing.is_empty() {
            return PolicyDecision::Deny {
                error: KernelError::new(
                    ErrorCode::CapabilityDenied,
                    format!("capabilities not granted for {service_id}"),
                )
                .with_details(json!({
                    "service": service_id,
                    "missing": missing,
                })),
            };
        }

        // Grant only the requested capability subset (capability least privilege).
        PolicyDecision::Allow {
            granted: requested.into_iter().collect(),
        }
    }

    pub fn decide_allow(
        &self,
        service: &ServiceDescriptor,
        requested_capabilities: &[String],
    ) -> Result<Vec<String>> {
        match self.decide(service, requested_capabilities) {
            PolicyDecision::Allow { granted } => Ok(granted),
            PolicyDecision::Deny { error } => Err(error),
        }
    }
}
