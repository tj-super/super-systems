import { $ } from "bun";
import { existsSync } from "node:fs";

interface HostConfig {
  privateKeyFile?: string;
  publicKey?: string;
  [key: string]: unknown;
}

type HostsMap = Record<string, HostConfig>;

const hostsJsonRaw = process.env.HOSTS_JSON;
if (!hostsJsonRaw) {
  console.error("Error: HOSTS_JSON environment variable is not set.");
  process.exit(1);
}

const hosts: HostsMap = JSON.parse(hostsJsonRaw);

const [command, hostName] = Bun.argv.slice(2);

if (!command || !hostName) {
  showHelp();
  process.exit(1);
}

const hostConfig = hosts[hostName];

let projectRoot: string;
try {
  projectRoot = (await $`git rev-parse --show-toplevel`.text()).trim();
} catch {
  projectRoot = process.cwd();
}

async function buildHost(host: string) {
  console.log(`Building VM for host: ${host}...`);
  await $`nix build .#nixosConfigurations.${host}.config.system.build.vm`;
}

async function runHost(host: string) {
  if (!hostConfig) {
    console.error(`Error: Host '${host}' not found in hosts map.`);
    process.exit(1);
  }

  const { privateKeyFile, publicKey } = hostConfig;

  if (!privateKeyFile) {
    console.error(`Error: Missing 'privateKeyFile' for host '${host}'.`);
    process.exit(1);
  }

  if (!existsSync(privateKeyFile)) {
    console.error(`Error: Private key file '${privateKeyFile}' not found.`);
    process.exit(1);
  }

  const sharedDir = (await $`mktemp -d`.text()).trim();

  try {
    const homedir = Bun.env.HOME || "~";
    const keyPath = `${sharedDir}/ssh_host_ed25519_key`;

    await $`age -d -i ${projectRoot}/secrets.key -o ${keyPath} ${privateKeyFile}`;

    if (publicKey) {
      await Bun.write(`${keyPath}.pub`, publicKey);
    }

    await buildHost(host);
    await $`SHARED_DIR=${sharedDir} ./result/bin/run-${host}-vm`;
  } finally {
    if (existsSync(sharedDir)) {
      await $`rm -rf ${sharedDir}`;
    }
  }
}

function showHelp() {
  console.log(`
hosts-ts

Usage:
  hosts-ts <command> <host-name>

Commands:
  build-host   Build the NixOS VM for the specified host
  run-host     Build and run the NixOS VM for the specified host
  help         Show this help message
`);
}

switch (command) {
  case "build-host":
    await buildHost(hostName);
    break;

  case "run-host":
    await runHost(hostName);
    break;

  case "help":
  case "-h":
  case "--help":
    showHelp();
    process.exit(0);
  default:
    showHelp();
    process.exit(1);
}
