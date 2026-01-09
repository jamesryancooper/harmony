#!/usr/bin/env node
/**
 * Install (or uninstall) the Harmony Theme extension for Cursor.
 *
 * This script:
 * - Copies `packages/theme-pack/` into Cursor's extensions folder using the
 *   `publisher.name-version` naming convention.
 * - Registers the extension in Cursor's extension lists (including profile lists).
 * - Removes the extension from Cursor's `.obsolete` list if present.
 *
 * Usage:
 *   node scripts/install-cursor-harmony-theme.js
 *   node scripts/install-cursor-harmony-theme.js --uninstall
 */

/* eslint-disable no-console */

const fs = require("fs");
const os = require("os");
const path = require("path");
const { pathToFileURL } = require("url");

const repoRoot = path.resolve(__dirname, "..");
const themePackageDir = path.join(repoRoot, "packages", "theme-pack");
const themePackageJsonPath = path.join(themePackageDir, "package.json");

function exists(p) {
  try {
    fs.accessSync(p);
    return true;
  } catch {
    return false;
  }
}

function readJson(p) {
  return JSON.parse(fs.readFileSync(p, "utf8"));
}

function writeJsonPretty(p, value) {
  fs.writeFileSync(p, JSON.stringify(value, null, 2) + "\n", "utf8");
}

function writeJsonMinified(p, value) {
  fs.writeFileSync(p, JSON.stringify(value) + "\n", "utf8");
}

function backupOnce(p) {
  if (!exists(p)) return;
  const backupPath = `${p}.bak`;
  if (exists(backupPath)) return;
  fs.copyFileSync(p, backupPath);
}

function rimraf(p) {
  if (!exists(p)) return;
  fs.rmSync(p, { recursive: true, force: true });
}

function copyDir(src, dest) {
  fs.mkdirSync(path.dirname(dest), { recursive: true });
  rimraf(dest);
  fs.cpSync(src, dest, { recursive: true });
}

function getCursorUserDataDir() {
  const home = os.homedir();

  const candidates = [];
  if (process.platform === "darwin") {
    candidates.push(path.join(home, "Library", "Application Support", "Cursor", "User"));
  } else if (process.platform === "win32") {
    const appData = process.env.APPDATA || path.join(home, "AppData", "Roaming");
    candidates.push(path.join(appData, "Cursor", "User"));
  } else {
    const xdg = process.env.XDG_CONFIG_HOME || path.join(home, ".config");
    candidates.push(path.join(xdg, "Cursor", "User"));
  }

  for (const p of candidates) {
    if (exists(p)) return p;
  }
  return null;
}

function removeFromObsolete(cursorExtensionsDir, extensionFolderName) {
  const obsoletePath = path.join(cursorExtensionsDir, ".obsolete");
  if (!exists(obsoletePath)) return;

  backupOnce(obsoletePath);

  try {
    const data = readJson(obsoletePath);
    if (data && typeof data === "object" && !Array.isArray(data)) {
      if (Object.prototype.hasOwnProperty.call(data, extensionFolderName)) {
        delete data[extensionFolderName];
        writeJsonMinified(obsoletePath, data);
      }
    }
  } catch {
    // If the file isn't valid JSON, don't try to rewrite it.
  }
}

function upsertExtensionListEntry(listPath, entryMatcher, newEntry) {
  backupOnce(listPath);

  let list = [];
  if (exists(listPath)) {
    try {
      list = readJson(listPath);
    } catch {
      list = [];
    }
  }

  if (!Array.isArray(list)) list = [];

  const idx = list.findIndex(entryMatcher);
  if (idx >= 0) {
    list[idx] = {
      ...list[idx],
      ...newEntry,
      identifier: newEntry.identifier ?? list[idx].identifier,
      metadata: newEntry.metadata ?? list[idx].metadata,
    };
  } else {
    list.push(newEntry);
  }

  writeJsonPretty(listPath, list);
}

function registerInCursorExtensionsJson(cursorExtensionsDir, extensionId, extensionVersion, extensionFolderName, destDir) {
  const extensionsJsonPath = path.join(cursorExtensionsDir, "extensions.json");
  const fileUrl = pathToFileURL(destDir).toString();

  const entry = {
    identifier: { id: extensionId },
    version: extensionVersion,
    location: {
      $mid: 1,
      fsPath: destDir,
      external: fileUrl,
      path: destDir,
      scheme: "file",
    },
    relativeLocation: extensionFolderName,
    metadata: {
      isApplicationScoped: false,
      isMachineScoped: false,
      isBuiltin: false,
      installedTimestamp: Date.now(),
      pinned: false,
      source: "vsix",
    },
  };

  upsertExtensionListEntry(
    extensionsJsonPath,
    (e) =>
      (e?.identifier?.id === extensionId) ||
      (e?.relativeLocation === extensionFolderName) ||
      (typeof e?.location?.path === "string" && e.location.path === destDir),
    entry,
  );
}

function registerInProfileExtensions(userDataDir, extensionId, extensionVersion, extensionFolderName, destDir) {
  if (!userDataDir) return;

  const profilesDir = path.join(userDataDir, "profiles");
  if (!exists(profilesDir)) return;

  const profileDirs = fs
    .readdirSync(profilesDir, { withFileTypes: true })
    .filter((d) => d.isDirectory())
    .map((d) => path.join(profilesDir, d.name));

  for (const profileDir of profileDirs) {
    const profileExtensionsJson = path.join(profileDir, "extensions.json");
    if (!exists(profileExtensionsJson)) continue;

    const entry = {
      identifier: { id: extensionId },
      version: extensionVersion,
      location: { $mid: 1, path: destDir, scheme: "file" },
      relativeLocation: extensionFolderName,
      metadata: {
        isApplicationScoped: false,
        isMachineScoped: false,
        isBuiltin: false,
        installedTimestamp: Date.now(),
        pinned: false,
        source: "vsix",
      },
    };

    upsertExtensionListEntry(
      profileExtensionsJson,
      (e) =>
        (e?.identifier?.id === extensionId) ||
        (e?.relativeLocation === extensionFolderName) ||
        (typeof e?.location?.path === "string" && e.location.path === destDir),
      entry,
    );
  }
}

function unregisterEverywhere(cursorExtensionsDir, userDataDir, extensionId, extensionFolderName, destDir) {
  const removeFromListFile = (listPath) => {
    if (!exists(listPath)) return;
    backupOnce(listPath);

    let list;
    try {
      list = readJson(listPath);
    } catch {
      return;
    }

    if (!Array.isArray(list)) return;

    const next = list.filter(
      (e) =>
        e?.identifier?.id !== extensionId &&
        e?.relativeLocation !== extensionFolderName &&
        e?.location?.path !== destDir &&
        e?.location?.fsPath !== destDir,
    );

    writeJsonPretty(listPath, next);
  };

  removeFromListFile(path.join(cursorExtensionsDir, "extensions.json"));

  if (userDataDir) {
    const profilesDir = path.join(userDataDir, "profiles");
    if (exists(profilesDir)) {
      const profileDirs = fs
        .readdirSync(profilesDir, { withFileTypes: true })
        .filter((d) => d.isDirectory())
        .map((d) => path.join(profilesDir, d.name));

      for (const profileDir of profileDirs) {
        removeFromListFile(path.join(profileDir, "extensions.json"));
      }
    }
  }
}

function main() {
  if (!exists(themePackageJsonPath)) {
    console.error(`Could not find ${path.relative(repoRoot, themePackageJsonPath)}.`);
    process.exit(1);
  }

  const pkg = readJson(themePackageJsonPath);
  const publisher = pkg.publisher;
  const name = pkg.name;
  const version = pkg.version;
  const contributedThemes = Array.isArray(pkg?.contributes?.themes) ? pkg.contributes.themes : [];

  if (!publisher || !name || !version) {
    console.error("Theme package.json must include publisher, name, and version.");
    process.exit(1);
  }

  const extensionId = `${publisher}.${name}`;
  const extensionFolderName = `${extensionId}-${version}`;

  const home = os.homedir();
  const cursorExtensionsDir = path.join(home, ".cursor", "extensions");
  const destDir = path.join(cursorExtensionsDir, extensionFolderName);

  const args = new Set(process.argv.slice(2));
  const uninstall = args.has("--uninstall") || args.has("uninstall");

  if (!exists(cursorExtensionsDir)) {
    fs.mkdirSync(cursorExtensionsDir, { recursive: true });
  }

  const userDataDir = getCursorUserDataDir();

  if (uninstall) {
    console.log(`Uninstalling ${extensionId}@${version}...`);
    unregisterEverywhere(cursorExtensionsDir, userDataDir, extensionId, extensionFolderName, destDir);
    rimraf(destDir);
    console.log("Done.");
    console.log("Restart Cursor (Cmd+Q) to finish uninstall.");
    return;
  }

  console.log(`Installing ${extensionId}@${version}...`);
  copyDir(themePackageDir, destDir);
  removeFromObsolete(cursorExtensionsDir, extensionFolderName);
  registerInCursorExtensionsJson(cursorExtensionsDir, extensionId, version, extensionFolderName, destDir);
  registerInProfileExtensions(userDataDir, extensionId, version, extensionFolderName, destDir);

  // Sanity-check contributed themes after install.
  const themeLabels = [];
  const problems = [];
  for (const theme of contributedThemes) {
    const label = theme?.label;
    const rel = theme?.path;

    if (typeof label === "string" && label.trim()) themeLabels.push(label.trim());
    if (typeof rel !== "string" || !rel.trim()) continue;

    const abs = path.resolve(destDir, rel);
    if (!exists(abs)) {
      problems.push(`Missing theme file: ${rel}`);
      continue;
    }

    try {
      const parsed = JSON.parse(fs.readFileSync(abs, "utf8"));
      if (!parsed || typeof parsed !== "object") {
        problems.push(`Theme JSON is not an object: ${rel}`);
      } else if (typeof parsed.name !== "string" || !parsed.name.trim()) {
        problems.push(`Theme JSON missing "name": ${rel}`);
      }
    } catch (e) {
      problems.push(`Theme JSON failed to parse (${rel}): ${String(e?.message || e)}`);
    }
  }

  console.log("Done.");
  console.log(`Installed to: ${destDir}`);

  if (problems.length) {
    console.warn("\nWarnings:");
    for (const p of problems) console.warn(`- ${p}`);
  }

  console.log("Restart Cursor (Cmd+Q) and reopen it, then choose:");
  if (themeLabels.length) {
    for (const label of themeLabels) {
      console.log(`  Preferences: Color Theme → ${label}`);
    }
  } else {
    console.log("  Preferences: Color Theme → (choose a Harmony theme)");
  }
}

main();

