# Containerized Vulnerability Lab & Automated Telemetry System

## Overview
This project provides a fully automated, isolated Cyber Range designed for security auditing and telemetry generation. It deploys a 2-tier architecture (Web Server and Database) populated with dynamically generated mock data, acting as vulnerable targets. A custom "Sentinel Node" acts as the attacker/auditor, scanning the isolated network, identifying open ports and sending real-time HTTP POST alerts via Discord webhooks.

This environment is built with a focus on **Developer Experience (DX)**, featuring one-click deployment and a complete teardown process.

## Scope & Learning Objectives (Why this project?)
This project was developed as a comprehensive hands-on laboratory to study modern infrastructure and scripting technologies. The core objectives include:
* **Infrastructure as Code (IaC):** Deep dive into Docker, custom Dockerfiles, volume persistence and network isolation via `docker-compose`.
* **System Administration:** Advanced Bash scripting, process management (signals/termination), OS detection and automated dependency handling.
* **Network Security:** Raw socket programming in Python for active port scanning and banner grabbing.
* **Modern Telemetry:** Integrating with external APIs (Discord Webhooks) for real-time security alerting across platforms (e.g. desktop to phone).

## Architecture & Design Decisions
The infrastructure is orchestrated via `docker-compose` and focuses on strict network isolation and Defense in Depth:
* **Target-Web (Nginx):** The only externally exposed service (Port `8080`), serving a dynamically generated HTML intranet directory.
* **Target-DB (MySQL):** Operates securely within the internal Docker network. Its port (`3306`) is **unexposed** to the host machine, making it accessible only to the internal Sentinel Node.
* **Sentinel Node:** A custom-built Ubuntu container containing Python network scanners and Bash auditing scripts alongside log files. Specifically, it maps a local volume for persistent log storage.
* **Dependency Management:** The Web Server strictly waits for the Database to initialize via orchestration logic.

## Dynamic Directory Structure
The repository is designed to be lightweight. No hardcoded data or "garbage" files are committed to version control.

```text
containerized-telemetry-platform/
├── docker-compose.yaml      # Infrastructure orchestration blueprint
├── Dockerfile               # Custom image build for the sentinel_node container
├── setup.sh                 # One-click bootstrap & deployment script
├── cleanup.sh               # Complete teardown and artifact removal script
├── system_audit.sh          # Master auditing and webhook alerting tool
├── network_scanner.py       # Socket-based internal network scanner
├── logs/                    # Persistent mount point (Dynamically populated)
│   ├── Threat.log           # Generated at runtime
│   └── audit.log            # Generated at runtime
└── data_seeder/             # Data generation engine before first docker initialization
    ├── account_creation.sh  
    ├── username_generator.py 
    ├── password_generator.py 
    ├── index.html           # Generated at runtime by setup.sh
    └── init.sql             # Generated at runtime by setup.sh
```
*(Note: index.html, init.sql and log files do not exist initially. They are generated dynamically during the Bootstrap phase).*

## Prerequisites
To run this project, ensure your host machine has the following installed:
* A Linux-based OS (Ubuntu, Kali, etc.)
* Git
* Docker Engine
* Docker Compose

## Lifecycle & Usage

### 1. Bootstrap & Deployment (One-Click Setup)
The setup process handles file permissions, generates 500 mock user accounts (HTML & SQL formats), and orchestrates the containers silently in the background.

```bash
# Give execution rights to the setup script
chmod +x setup.sh

# Run the automated deployment
./setup.sh
```
*Once completed, the script will automatically attach your terminal to the internal sentinel_node container.*

### 2. Running the Security Audit
While inside the sentinel_node container, run the main auditing tool. The script will interactively ask for a Discord Webhook URL (saving it securely to a .env file) to send real-time alerts when vulnerabilities (like the open MySQL or nginx port) are found.

```bash
./system_audit.sh
```

### 3. Reviewing the Telemetry (Persistence)
Exit the container (`exit`). Because the `logs/` directory is mapped as a Docker Volume, all security reports survive the container's lifecycle. You can review them directly from your host machine:

```bash
cat logs/Threat.log
```

### 4. Teardown (Self-Destruct)
To remove the infrastructure and leave your system completely clean, run the teardown script. This will stop the containers, remove the custom network, delete the Docker volumes and wipe all dynamically generated artifacts (.sql, .html, and logs), removing the entire repo from the system.

```bash
# Give execution rights if necessary
chmod +x cleanup.sh

# Execute complete environment wipe
./cleanup.sh
```
