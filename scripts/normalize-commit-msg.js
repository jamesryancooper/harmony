#!/usr/bin/env node
"use strict";

const fs = require("node:fs");

const MAX_LINE_LENGTH = 72;
const DEFAULT_TYPE = "chore";
const DEFAULT_SCOPE = "repo";
const DEFAULT_SUBJECT = "update repository";
const ALLOWED_TYPES = new Set([
  "feat",
  "fix",
  "refactor",
  "perf",
  "test",
  "docs",
  "chore",
  "ci",
  "revert",
]);

function isCommentLine(line) {
  return /^\s*#/.test(line);
}

function collapseWhitespace(value) {
  return value.trim().replace(/\s+/g, " ");
}

function normalizeScope(scope) {
  const normalized = collapseWhitespace(scope)
    .toLowerCase()
    .replace(/[\s_]+/g, "-")
    .replace(/[^a-z0-9/-]/g, "-")
    .replace(/-+/g, "-")
    .replace(/^[-/]+|[-/]+$/g, "");

  return normalized || DEFAULT_SCOPE;
}

function normalizeSubject(subject) {
  const normalized = collapseWhitespace(subject)
    .replace(/\.+$/g, "")
    .toLowerCase();

  return normalized || DEFAULT_SUBJECT;
}

function chooseBreakIndex(token, maxWidth) {
  if (token.length <= maxWidth) {
    return token.length;
  }

  const minimum = Math.max(1, Math.floor(maxWidth * 0.6));
  for (let i = maxWidth; i >= minimum; i -= 1) {
    if ("/-_.:,#=".includes(token[i - 1])) {
      return i;
    }
  }

  return Math.max(1, maxWidth);
}

function wrapText(text, firstWidth, nextWidth) {
  const words = collapseWhitespace(text).split(" ").filter(Boolean);
  if (!words.length) {
    return [""];
  }

  const lines = [];
  let current = "";
  let width = firstWidth;

  for (const rawWord of words) {
    let word = rawWord;
    while (word.length > 0) {
      if (!current) {
        if (word.length <= width) {
          current = word;
          word = "";
          continue;
        }

        const cut = chooseBreakIndex(word, width);
        lines.push(word.slice(0, cut));
        word = word.slice(cut);
        width = nextWidth;
        continue;
      }

      if (current.length + 1 + word.length <= width) {
        current += ` ${word}`;
        word = "";
        continue;
      }

      lines.push(current);
      current = "";
      width = nextWidth;
    }
  }

  if (current) {
    lines.push(current);
  }

  return lines;
}

function splitHeader(prefix, subject) {
  const firstWidth = MAX_LINE_LENGTH - prefix.length;
  const wrappedSubject =
    firstWidth > 0
      ? wrapText(subject, firstWidth, MAX_LINE_LENGTH)
      : wrapText(subject, MAX_LINE_LENGTH, MAX_LINE_LENGTH);

  return {
    header: `${prefix}${wrappedSubject[0] || DEFAULT_SUBJECT}`,
    overflow: wrappedSubject.slice(1),
  };
}

function normalizeHeader(headerLine) {
  const trimmed = headerLine.trim();
  const headerPattern = /^([A-Za-z]+)(?:\(([^)]+)\))?(!)?:\s*(.*)$/;
  const match = trimmed.match(headerPattern);

  let type = DEFAULT_TYPE;
  let scope = DEFAULT_SCOPE;
  let breaking = "";
  let subject = trimmed;

  if (match) {
    type = (match[1] || DEFAULT_TYPE).toLowerCase();
    scope = normalizeScope(match[2] || DEFAULT_SCOPE);
    breaking = match[3] || "";
    subject = match[4] || "";
  } else {
    const noScopeMatch = trimmed.match(/^([A-Za-z]+):\s*(.*)$/);
    if (noScopeMatch) {
      type = (noScopeMatch[1] || DEFAULT_TYPE).toLowerCase();
      subject = noScopeMatch[2] || "";
    }
  }

  if (!ALLOWED_TYPES.has(type)) {
    type = DEFAULT_TYPE;
  }

  subject = normalizeSubject(subject);
  let prefix = `${type}(${scope})${breaking}: `;
  if (prefix.length >= MAX_LINE_LENGTH) {
    scope = DEFAULT_SCOPE;
    prefix = `${type}(${scope})${breaking}: `;
  }

  return splitHeader(prefix, subject);
}

function wrapCommitLine(line) {
  const trimmed = line.replace(/[ \t]+$/g, "");
  if (trimmed.length <= MAX_LINE_LENGTH) {
    return [trimmed];
  }

  const indentMatch = trimmed.match(/^(\s*)(.*)$/);
  const indent = indentMatch ? indentMatch[1] : "";
  let text = indentMatch ? indentMatch[2] : trimmed;
  let marker = "";
  let continuationMarker = "";

  const bulletMatch = text.match(/^([-*+]\s+)(.*)$/);
  const numberedMatch = text.match(/^(\d+\.\s+)(.*)$/);
  const quoteMatch = text.match(/^(>+\s+)(.*)$/);
  const footerMatch = text.match(/^([A-Za-z-]+(?:\s[A-Za-z-]+)*:\s+)(.*)$/);

  if (bulletMatch) {
    marker = bulletMatch[1];
    continuationMarker = " ".repeat(marker.length);
    text = bulletMatch[2];
  } else if (numberedMatch) {
    marker = numberedMatch[1];
    continuationMarker = " ".repeat(marker.length);
    text = numberedMatch[2];
  } else if (quoteMatch) {
    marker = quoteMatch[1];
    continuationMarker = marker;
    text = quoteMatch[2];
  } else if (footerMatch) {
    marker = footerMatch[1];
    continuationMarker = " ".repeat(marker.length);
    text = footerMatch[2];
  }

  const firstPrefix = `${indent}${marker}`;
  const nextPrefix = `${indent}${continuationMarker}`;
  const firstWidth = Math.max(1, MAX_LINE_LENGTH - firstPrefix.length);
  const nextWidth = Math.max(1, MAX_LINE_LENGTH - nextPrefix.length);
  const wrapped = wrapText(text, firstWidth, nextWidth);

  return wrapped.map((part, index) =>
    index === 0 ? `${firstPrefix}${part}` : `${nextPrefix}${part}`
  );
}

function findHeaderIndex(lines) {
  for (let i = 0; i < lines.length; i += 1) {
    if (isCommentLine(lines[i])) {
      continue;
    }
    if (lines[i].trim() === "") {
      continue;
    }
    return i;
  }
  return -1;
}

function insertHeaderOverflow(lines, headerIndex, overflowLines) {
  if (!overflowLines.length) {
    return;
  }

  let insertIndex = headerIndex + 1;
  if (insertIndex >= lines.length || lines[insertIndex].trim() !== "") {
    lines.splice(insertIndex, 0, "");
    insertIndex += 1;
  } else {
    insertIndex += 1;
  }

  lines.splice(insertIndex, 0, ...overflowLines);
}

function normalizeCommitMessage(rawMessage) {
  const eol = rawMessage.includes("\r\n") ? "\r\n" : "\n";
  const lines = rawMessage.split(/\r?\n/);
  const headerIndex = findHeaderIndex(lines);

  if (headerIndex < 0) {
    return rawMessage;
  }

  const { header, overflow } = normalizeHeader(lines[headerIndex]);
  lines[headerIndex] = header;
  insertHeaderOverflow(lines, headerIndex, overflow);

  for (let i = 0; i < lines.length; i += 1) {
    if (i === headerIndex || isCommentLine(lines[i]) || lines[i].trim() === "") {
      continue;
    }

    const wrapped = wrapCommitLine(lines[i]);
    if (wrapped.length === 1 && wrapped[0] === lines[i]) {
      continue;
    }

    lines.splice(i, 1, ...wrapped);
    i += wrapped.length - 1;
  }

  return lines.join(eol);
}

function main() {
  const commitMessageFile = process.argv[2];
  if (!commitMessageFile) {
    console.error("normalize-commit-msg: missing commit message file path");
    process.exit(1);
  }

  try {
    const original = fs.readFileSync(commitMessageFile, "utf8");
    const normalized = normalizeCommitMessage(original);
    if (normalized !== original) {
      fs.writeFileSync(commitMessageFile, normalized, "utf8");
    }
  } catch (error) {
    console.error(`normalize-commit-msg: ${error.message}`);
    process.exit(1);
  }
}

main();
