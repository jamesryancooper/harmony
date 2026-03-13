use crate::errors::{ErrorCode, KernelError, Result};
use std::path::{Path, PathBuf};

/// Resolves the repository-root `.harmony/` directory for the active workspace.
pub struct RootResolver;

impl RootResolver {
    /// Resolve from an explicit starting directory.
    pub fn resolve_from(start: &Path) -> Result<PathBuf> {
        if let Some(override_path) = override_harmony_dir()? {
            return Ok(override_path);
        }

        let cur = start
            .canonicalize()
            .map_err(|e| KernelError::new(ErrorCode::Internal, format!("failed to canonicalize cwd: {e}")))?;

        if let Some(candidate) = cur
            .ancestors()
            .map(|ancestor| ancestor.join(".harmony"))
            .filter(|candidate| candidate.is_dir())
            .last()
        {
            return Ok(candidate);
        }

        Err(KernelError::new(
            ErrorCode::Internal,
            "no repository-root .harmony directory found in any parent of cwd",
        ))
    }

    /// Resolve from the current working directory.
    pub fn resolve() -> Result<PathBuf> {
        if let Some(override_path) = override_harmony_dir()? {
            return Ok(override_path);
        }

        let cwd = std::env::current_dir()
            .map_err(|e| KernelError::new(ErrorCode::Internal, format!("failed to read cwd: {e}")))?;
        Self::resolve_from(&cwd)
    }
}

fn override_harmony_dir() -> Result<Option<PathBuf>> {
    if let Some(harmony_dir) = std::env::var_os("HARMONY_DIR_OVERRIDE") {
        let path = PathBuf::from(harmony_dir);
        let canonical = path.canonicalize().map_err(|e| {
            KernelError::new(
                ErrorCode::Internal,
                format!("failed to canonicalize HARMONY_DIR_OVERRIDE {}: {e}", path.display()),
            )
        })?;
        if !canonical.is_dir() {
            return Err(KernelError::new(
                ErrorCode::Internal,
                format!("HARMONY_DIR_OVERRIDE is not a directory: {}", canonical.display()),
            ));
        }
        return Ok(Some(canonical));
    }

    if let Some(root_dir) = std::env::var_os("HARMONY_ROOT_DIR") {
        let root = PathBuf::from(root_dir);
        let harmony_dir = root.join(".harmony");
        let canonical = harmony_dir.canonicalize().map_err(|e| {
            KernelError::new(
                ErrorCode::Internal,
                format!("failed to canonicalize HARMONY_ROOT_DIR/.harmony {}: {e}", harmony_dir.display()),
            )
        })?;
        if !canonical.is_dir() {
            return Err(KernelError::new(
                ErrorCode::Internal,
                format!("HARMONY_ROOT_DIR does not contain .harmony/: {}", canonical.display()),
            ));
        }
        return Ok(Some(canonical));
    }

    Ok(None)
}

#[cfg(test)]
mod tests {
    use super::RootResolver;
    use std::fs;
    use std::path::{Path, PathBuf};
    use std::time::{SystemTime, UNIX_EPOCH};

    struct TempTree {
        root: PathBuf,
    }

    impl TempTree {
        fn new(name: &str) -> Self {
            let unique = SystemTime::now()
                .duration_since(UNIX_EPOCH)
                .expect("clock should be after unix epoch")
                .as_nanos();
            let root = std::env::temp_dir().join(format!(
                "harmony-root-resolver-{name}-{}-{unique}",
                std::process::id()
            ));
            fs::create_dir_all(&root).expect("temp tree should be created");
            Self { root }
        }

        fn path(&self) -> &Path {
            &self.root
        }
    }

    impl Drop for TempTree {
        fn drop(&mut self) {
            let _ = fs::remove_dir_all(&self.root);
        }
    }

    #[test]
    fn resolves_outermost_harmony_directory_when_multiple_matches_exist() {
        let tree = TempTree::new("outermost");
        let repo_root = tree.path().join("repo");
        let lower_level_root = repo_root.join("packages/flowkit");
        let cwd = lower_level_root.join("src");

        fs::create_dir_all(repo_root.join(".harmony")).expect("repo harness should be created");
        fs::create_dir_all(lower_level_root.join(".harmony")).expect("lower-level match should be created");
        fs::create_dir_all(&cwd).expect("cwd should be created");

        let resolved = RootResolver::resolve_from(&cwd).expect("root harness should resolve");

        assert_eq!(
            resolved,
            repo_root
                .join(".harmony")
                .canonicalize()
                .expect("expected harness path should canonicalize")
        );
    }

    #[test]
    fn errors_when_no_harmony_directory_exists() {
        let tree = TempTree::new("missing");
        let cwd = tree.path().join("repo/src");
        fs::create_dir_all(&cwd).expect("cwd should be created");

        let error = RootResolver::resolve_from(&cwd).expect_err("missing harness should fail");

        assert!(
            error
                .to_string()
                .contains("no repository-root .harmony directory found"),
            "unexpected error: {error}"
        );
    }
}
