# Tool Installation Guide - Phase IV Prerequisites

**Purpose**: Install all required tools for Phase IV Kubernetes deployment
**Platform**: Windows 10/11
**Time**: ~15-30 minutes
**Last Updated**: 2026-01-28

---

## Current Status

| Tool | Status | Version | Action Needed |
|------|--------|---------|---------------|
| **Docker Desktop** | ⚠️ Installed, daemon not running | 29.1.3 | Start Docker Desktop |
| **kubectl** | ✅ Installed | 1.34.1 | None |
| **Minikube** | ❌ Not installed | - | Install |
| **Helm** | ❌ Not installed | - | Install |

---

## 1. Docker Desktop (Start the Daemon)

**Status**: Installed but not running

### Steps:

1. **Start Docker Desktop**:
   - Press `Windows Key`
   - Type "Docker Desktop"
   - Click to launch
   - Wait for Docker icon in system tray to show "Docker Desktop is running"

2. **Verify Docker is running**:
   ```powershell
   docker --version
   docker ps
   ```

   Expected output:
   ```
   Docker version 29.1.3, build f52814d
   CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
   ```

3. **Configure Docker Resources** (Recommended):
   - Right-click Docker icon in system tray
   - Settings → Resources
   - Set:
     - CPUs: 4 (minimum 2)
     - Memory: 8GB (minimum 4GB)
     - Disk: 40GB (minimum 20GB)
   - Click "Apply & Restart"

### Troubleshooting:

**Issue**: Docker won't start
- Check Windows Subsystem for Linux (WSL2) is enabled
- Run: `wsl --install` in PowerShell (admin)
- Restart computer

**Issue**: "Docker Desktop requires a newer WSL kernel"
- Run: `wsl --update`
- Restart Docker Desktop

---

## 2. Minikube Installation

**Status**: Not installed

### Method 1: Using Winget (Recommended)

```powershell
# Open PowerShell as Administrator
winget install Kubernetes.minikube
```

### Method 2: Using Chocolatey

```powershell
# If you have Chocolatey installed
choco install minikube
```

### Method 3: Manual Installation

1. **Download Minikube**:
   - Go to: https://minikube.sigs.k8s.io/docs/start/
   - Click "Download" for Windows
   - Or direct download: https://storage.googleapis.com/minikube/releases/latest/minikube-installer.exe

2. **Install**:
   - Run the downloaded installer
   - Follow installation wizard
   - Keep default settings

3. **Add to PATH** (if not automatic):
   ```powershell
   # The installer usually adds to PATH automatically
   # If not, add: C:\Program Files\Minikube to your PATH
   ```

### Verify Installation:

```powershell
minikube version
```

Expected output:
```
minikube version: v1.32.0
commit: <hash>
```

### Configure Minikube:

```powershell
# Set Docker as the driver (recommended for Windows)
minikube config set driver docker

# Set resource defaults
minikube config set cpus 2
minikube config set memory 4096
minikube config set disk-size 20g
```

### First Start (Test):

```powershell
# Start Minikube
minikube start

# Verify it's running
minikube status

# Expected output:
# minikube
# type: Control Plane
# host: Running
# kubelet: Running
# apiserver: Running
# kubeconfig: Configured
```

### Troubleshooting:

**Issue**: "Exiting due to HOST_JUJU"
- Docker Desktop must be running first
- Restart Docker Desktop and try again

**Issue**: "Unable to pick a default driver"
- Install Docker Desktop and ensure it's running
- Set driver manually: `minikube config set driver docker`

**Issue**: Minikube starts but kubectl can't connect
- Run: `minikube update-context`
- Verify: `kubectl cluster-info`

---

## 3. Helm Installation

**Status**: Not installed

### Method 1: Using Winget (Recommended)

```powershell
# Open PowerShell as Administrator
winget install Helm.Helm
```

### Method 2: Using Chocolatey

```powershell
choco install kubernetes-helm
```

### Method 3: Using Scoop

```powershell
scoop install helm
```

### Method 4: Manual Installation

1. **Download Helm**:
   - Go to: https://github.com/helm/helm/releases
   - Download: `helm-v3.XX.X-windows-amd64.zip`
   - Latest stable: https://get.helm.sh/helm-v3.14.0-windows-amd64.zip

2. **Extract and Install**:
   - Extract the ZIP file
   - Move `helm.exe` to: `C:\Program Files\Helm\`
   - Add `C:\Program Files\Helm\` to your PATH

3. **Add to PATH**:
   ```powershell
   # Open PowerShell as Administrator
   $env:Path += ";C:\Program Files\Helm"
   [Environment]::SetEnvironmentVariable("Path", $env:Path, [EnvironmentVariableTarget]::Machine)
   ```

### Verify Installation:

```powershell
helm version
```

Expected output:
```
version.BuildInfo{Version:"v3.14.0", GitCommit:"...", GitTreeState:"clean", GoVersion:"go1.21.5"}
```

### Initialize Helm (Optional):

```powershell
# Add stable charts repository
helm repo add stable https://charts.helm.sh/stable

# Add bitnami repository (popular)
helm repo add bitnami https://charts.bitnami.com/bitnami

# Update repositories
helm repo update
```

### Troubleshooting:

**Issue**: "helm: command not found" after installation
- Close and reopen PowerShell/Terminal
- Verify PATH: `$env:Path -split ';' | Select-String helm`

**Issue**: Helm installed but can't connect to Kubernetes
- Ensure Minikube is running: `minikube status`
- Verify kubectl works: `kubectl cluster-info`

---

## 4. Optional: kubectl-ai Plugin

**Status**: Not installed (optional for enhanced AI features)

### Prerequisites:
- kubectl installed ✅
- krew (kubectl plugin manager)

### Install krew:

```powershell
# Download and install krew
(New-Object System.Net.WebClient).DownloadFile("https://github.com/kubernetes-sigs/krew/releases/latest/download/krew-windows_amd64.tar.gz", "$env:TEMP\krew.tar.gz")

# Extract and install
cd $env:TEMP
tar -xvf krew.tar.gz
.\krew-windows_amd64.exe install krew

# Add to PATH
$env:Path += ";$env:USERPROFILE\.krew\bin"
[Environment]::SetEnvironmentVariable("Path", $env:Path, [EnvironmentVariableTarget]::User)
```

### Install kubectl-ai:

```powershell
kubectl krew install ai
```

### Verify:

```powershell
kubectl ai --version
```

---

## Complete Installation Verification

After installing all tools, run this verification script:

### PowerShell Verification Script:

```powershell
Write-Host "`n==================================" -ForegroundColor Cyan
Write-Host "  Tool Installation Verification" -ForegroundColor Cyan
Write-Host "==================================`n" -ForegroundColor Cyan

$allGood = $true

# Check Docker
Write-Host "[1/4] Checking Docker..." -ForegroundColor Yellow
try {
    $dockerVersion = docker --version 2>$null
    docker ps 2>$null | Out-Null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  ✓ Docker: $dockerVersion" -ForegroundColor Green
    } else {
        Write-Host "  ✗ Docker daemon not running" -ForegroundColor Red
        $allGood = $false
    }
} catch {
    Write-Host "  ✗ Docker not installed" -ForegroundColor Red
    $allGood = $false
}

# Check kubectl
Write-Host "[2/4] Checking kubectl..." -ForegroundColor Yellow
try {
    $kubectlVersion = kubectl version --client --short 2>$null
    Write-Host "  ✓ kubectl: $kubectlVersion" -ForegroundColor Green
} catch {
    Write-Host "  ✗ kubectl not installed" -ForegroundColor Red
    $allGood = $false
}

# Check Minikube
Write-Host "[3/4] Checking Minikube..." -ForegroundColor Yellow
try {
    $minikubeVersion = minikube version --short 2>$null
    Write-Host "  ✓ Minikube: $minikubeVersion" -ForegroundColor Green
} catch {
    Write-Host "  ✗ Minikube not installed" -ForegroundColor Red
    $allGood = $false
}

# Check Helm
Write-Host "[4/4] Checking Helm..." -ForegroundColor Yellow
try {
    $helmVersion = helm version --short 2>$null
    Write-Host "  ✓ Helm: $helmVersion" -ForegroundColor Green
} catch {
    Write-Host "  ✗ Helm not installed" -ForegroundColor Red
    $allGood = $false
}

Write-Host "`n==================================`n" -ForegroundColor Cyan

if ($allGood) {
    Write-Host "✓ All tools installed and working!" -ForegroundColor Green
    Write-Host "`nNext steps:" -ForegroundColor Yellow
    Write-Host "  1. cd kubernetes/scripts" -ForegroundColor White
    Write-Host "  2. ./deploy.sh" -ForegroundColor White
} else {
    Write-Host "✗ Some tools need attention" -ForegroundColor Red
    Write-Host "`nPlease fix the issues above and try again" -ForegroundColor Yellow
}
```

Save this as `verify-tools.ps1` and run:
```powershell
.\verify-tools.ps1
```

---

## Quick Installation (All at Once)

If you have **Winget** installed:

```powershell
# Run as Administrator
winget install Kubernetes.minikube
winget install Helm.Helm

# Start Docker Desktop manually (if not running)
Start-Process "C:\Program Files\Docker\Docker\Docker Desktop.exe"

# Wait 30 seconds for Docker to start
Start-Sleep -Seconds 30

# Verify all tools
docker --version
kubectl version --client
minikube version
helm version
```

---

## Post-Installation Setup

### 1. Start Minikube for the First Time:

```powershell
# Start with appropriate resources
minikube start --cpus=2 --memory=4096 --disk-size=20gb

# Verify cluster
kubectl cluster-info
kubectl get nodes
```

### 2. Verify kubectl Context:

```powershell
# Should show minikube as current context
kubectl config current-context

# Expected output: minikube
```

### 3. Enable Useful Minikube Addons:

```powershell
# Metrics server (for kubectl top)
minikube addons enable metrics-server

# Dashboard (optional)
minikube addons enable dashboard
```

---

## Now You're Ready!

All tools installed? Great! Proceed to deployment:

### Quick Deployment:

```bash
cd kubernetes/scripts
./deploy.sh
```

### Or Manual Steps:

1. **Configure secrets**:
   ```bash
   cd kubernetes/helm-chart/todo-chatbot
   cp values-local.yaml.example values-local.yaml
   # Edit values-local.yaml with your secrets
   ```

2. **Build images**:
   ```bash
   cd kubernetes/scripts
   ./build-images.sh
   ```

3. **Deploy**:
   ```bash
   ./deploy.sh
   ```

4. **Validate**:
   ```bash
   ./validate.sh
   ```

5. **Access application**:
   - Frontend: http://localhost:30080
   - Backend: http://localhost:30800

---

## Getting Help

**Installation Issues**:
- Docker: https://docs.docker.com/desktop/troubleshoot/overview/
- Minikube: https://minikube.sigs.k8s.io/docs/start/
- Helm: https://helm.sh/docs/intro/install/

**Deployment Issues**:
- See: `specs/001-k8s-local-deployment/quickstart.md`
- Troubleshooting section has 15+ common scenarios

**Still Stuck**:
- Check tool versions are compatible
- Ensure Windows version is up to date
- Try restarting computer after installations
- Check Windows Defender/Firewall settings

---

**Installation Time Estimate**:
- Docker (already installed): 2 min to start
- Minikube: 5 min to install + configure
- Helm: 2 min to install
- Verification: 2 min
- **Total**: ~15-20 minutes

Good luck! 🚀
