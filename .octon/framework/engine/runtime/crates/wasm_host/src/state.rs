use wasmtime_wasi::{ResourceTable, WasiCtx, WasiView};

use crate::kv_store::KvStore;
use crate::policy::GrantSet;
use crate::scoped_fs::ScopedFs;
use octon_core::execution_integrity::{ExecutionExceptionLeases, NetworkEgressPolicy};
use octon_core::trace::TraceWriter;
use std::path::PathBuf;

pub struct HostState {
    pub wasi_ctx: WasiCtx,
    pub table: ResourceTable,

    // Octon-specific state
    pub grants: GrantSet,
    pub kv: KvStore,
    pub fs: ScopedFs,
    pub run_root: PathBuf,
    pub trace: Option<TraceWriter>,
    pub service_id: String,
    pub adapter_id: Option<String>,
    pub network_policy: NetworkEgressPolicy,
    pub exception_leases: ExecutionExceptionLeases,
}

impl WasiView for HostState {
    fn ctx(&mut self) -> &mut WasiCtx {
        &mut self.wasi_ctx
    }

    fn table(&mut self) -> &mut ResourceTable {
        &mut self.table
    }
}
