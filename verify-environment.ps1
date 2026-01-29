# Phase IV Environment Verification Script
# Purpose: Verify all prerequisites are installed and working
# Usage: .\verify-environment.ps1

param(
    [switch]$Detailed = $false
)

Write-Host "`n" -NoNewline
Write-Host "====================================================" -ForegroundColor Cyan
Write-Host "  Phase IV Environment Verification" -ForegroundColor Cyan
Write-Host "  Todo Chatbot Kubernetes Deployment" -ForegroundColor Cyan
Write-Host "====================================================" -ForegroundColor Cyan
Write-Host ""

$script:allGood = $true
$script:warnings = @()
$script:criticalIssues = @()

function Test-Tool {
    param(
        [string]$Name,
        [scriptblock]$Test,
        [string]$ExpectedPattern = "",
        [string]$InstallGuide = "",
        [bool]$Required = $true
    )

    Write-Host "[$Name] " -NoNewline -ForegroundColor Yellow

    try {
        $result = & $Test 2>&1
        $exitCode = $LASTEXITCODE

        if ($exitCode -eq 0 -and ($ExpectedPattern -eq "" -or $result -match $ExpectedPattern)) {
            Write-Host "✓ OK" -ForegroundColor Green
            if ($Detailed -and $result) {
                Write-Host "    $result" -ForegroundColor Gray
            }
            return $true
        } else {
            if ($Required) {
                Write-Host "✗ FAIL" -ForegroundColor Red
                $script:allGood = $false
                $script:criticalIssues += "$Name not working properly"
            } else {
                Write-Host "⚠ WARN (Optional)" -ForegroundColor Yellow
                $script:warnings += "$Name not available (optional)"
            }

            if ($InstallGuide) {
                Write-Host "    → $InstallGuide" -ForegroundColor Gray
            }
            return $false
        }
    } catch {
        if ($Required) {
            Write-Host "✗ NOT FOUND" -ForegroundColor Red
            $script:allGood = $false
            $script:criticalIssues += "$Name not installed"
        } else {
            Write-Host "⚠ NOT FOUND (Optional)" -ForegroundColor Yellow
            $script:warnings += "$Name not installed (optional)"
        }

        if ($InstallGuide) {
            Write-Host "    → $InstallGuide" -ForegroundColor Gray
        }
        return $false
    }
}

# Test 1: Docker
Write-Host "`n[1/6] Docker Desktop" -ForegroundColor Cyan
Write-Host "----------------------------------------" -ForegroundColor Gray

Test-Tool -Name "Docker Installed" `
    -Test { docker --version } `
    -ExpectedPattern "Docker version" `
    -InstallGuide "Already installed - just need to start Docker Desktop"

Test-Tool -Name "Docker Daemon Running" `
    -Test { docker ps } `
    -InstallGuide "Start Docker Desktop from Start menu"

# Test 2: kubectl
Write-Host "`n[2/6] kubectl" -ForegroundColor Cyan
Write-Host "----------------------------------------" -ForegroundColor Gray

$kubectlInstalled = Test-Tool -Name "kubectl Installed" `
    -Test { kubectl version --client --short } `
    -ExpectedPattern "Client Version" `
    -InstallGuide "Install from: https://kubernetes.io/docs/tasks/tools/"

if ($kubectlInstalled) {
    Test-Tool -Name "kubectl Can List Resources" `
        -Test { kubectl get nodes 2>$null } `
        -Required $false `
        -InstallGuide "Cluster not running yet (expected if Minikube not started)"
}

# Test 3: Minikube
Write-Host "`n[3/6] Minikube" -ForegroundColor Cyan
Write-Host "----------------------------------------" -ForegroundColor Gray

$minikubeInstalled = Test-Tool -Name "Minikube Installed" `
    -Test { minikube version --short } `
    -ExpectedPattern "v\d+\.\d+\.\d+" `
    -InstallGuide "See INSTALL_TOOLS.md #2 - Installation takes ~5 minutes"

if ($minikubeInstalled) {
    Test-Tool -Name "Minikube Cluster Running" `
        -Test { minikube status } `
        -ExpectedPattern "Running" `
        -Required $false `
        -InstallGuide "Start with: minikube start --cpus=2 --memory=4096"
}

# Test 4: Helm
Write-Host "`n[4/6] Helm" -ForegroundColor Cyan
Write-Host "----------------------------------------" -ForegroundColor Gray

Test-Tool -Name "Helm Installed" `
    -Test { helm version --short } `
    -ExpectedPattern "v\d+\.\d+\.\d+" `
    -InstallGuide "See INSTALL_TOOLS.md #3 - Installation takes ~2 minutes"

# Test 5: Phase III Application
Write-Host "`n[5/6] Phase III Application" -ForegroundColor Cyan
Write-Host "----------------------------------------" -ForegroundColor Gray

Test-Tool -Name "Frontend Directory" `
    -Test { Test-Path "../todo_phase3/frontend" } `
    -InstallGuide "Phase III application not found in expected location"

Test-Tool -Name "Backend Directory" `
    -Test { Test-Path "../todo_phase3/backend" } `
    -InstallGuide "Phase III application not found in expected location"

# Test 6: Configuration Files
Write-Host "`n[6/6] Configuration" -ForegroundColor Cyan
Write-Host "----------------------------------------" -ForegroundColor Gray

$valuesLocalExists = Test-Tool -Name "values-local.yaml" `
    -Test { Test-Path "kubernetes/helm-chart/todo-chatbot/values-local.yaml" } `
    -Required $false `
    -InstallGuide "Create from: kubernetes/helm-chart/todo-chatbot/values-local.yaml.example"

if (-not $valuesLocalExists) {
    Write-Host "    ℹ Run: " -NoNewline -ForegroundColor Cyan
    Write-Host "cd kubernetes/helm-chart/todo-chatbot; cp values-local.yaml.example values-local.yaml" -ForegroundColor White
    Write-Host "    Then edit with your secrets (DATABASE_URL, API keys, etc)" -ForegroundColor Gray
}

# System Resources Check
Write-Host "`n[BONUS] System Resources" -ForegroundColor Cyan
Write-Host "----------------------------------------" -ForegroundColor Gray

$cpu = (Get-CimInstance -ClassName Win32_Processor).NumberOfLogicalProcessors
$ramGB = [math]::Round((Get-CimInstance -ClassName Win32_ComputerSystem).TotalPhysicalMemory / 1GB, 2)
$freeSpaceGB = [math]::Round((Get-PSDrive C).Free / 1GB, 2)

Write-Host "CPU Cores: " -NoNewline
if ($cpu -ge 2) {
    Write-Host "$cpu ✓" -ForegroundColor Green
} else {
    Write-Host "$cpu (recommend 2+)" -ForegroundColor Yellow
}

Write-Host "RAM: " -NoNewline
if ($ramGB -ge 8) {
    Write-Host "${ramGB}GB ✓" -ForegroundColor Green
} elseif ($ramGB -ge 4) {
    Write-Host "${ramGB}GB (recommend 8GB+)" -ForegroundColor Yellow
} else {
    Write-Host "${ramGB}GB (minimum 4GB required)" -ForegroundColor Red
}

Write-Host "Free Disk Space: " -NoNewline
if ($freeSpaceGB -ge 20) {
    Write-Host "${freeSpaceGB}GB ✓" -ForegroundColor Green
} else {
    Write-Host "${freeSpaceGB}GB (recommend 20GB+)" -ForegroundColor Yellow
}

# Summary
Write-Host "`n" -NoNewline
Write-Host "====================================================" -ForegroundColor Cyan
Write-Host "  Summary" -ForegroundColor Cyan
Write-Host "====================================================" -ForegroundColor Cyan
Write-Host ""

if ($script:allGood) {
    Write-Host "✓ All critical tools are ready!" -ForegroundColor Green
    Write-Host ""

    if ($script:warnings.Count -gt 0) {
        Write-Host "⚠ Optional items:" -ForegroundColor Yellow
        $script:warnings | ForEach-Object {
            Write-Host "  - $_" -ForegroundColor Yellow
        }
        Write-Host ""
    }

    Write-Host "Next steps:" -ForegroundColor Cyan
    Write-Host "  1. Ensure values-local.yaml is configured with your secrets" -ForegroundColor White
    Write-Host "  2. cd kubernetes/scripts" -ForegroundColor White
    Write-Host "  3. ./deploy.sh" -ForegroundColor White
    Write-Host ""
    Write-Host "Documentation:" -ForegroundColor Cyan
    Write-Host "  - Quick start: QUICK_REFERENCE.md" -ForegroundColor White
    Write-Host "  - Full guide: specs/001-k8s-local-deployment/quickstart.md" -ForegroundColor White
    Write-Host ""

} else {
    Write-Host "✗ Some critical tools need attention" -ForegroundColor Red
    Write-Host ""
    Write-Host "Critical issues:" -ForegroundColor Red
    $script:criticalIssues | ForEach-Object {
        Write-Host "  - $_" -ForegroundColor Red
    }
    Write-Host ""
    Write-Host "Action required:" -ForegroundColor Yellow
    Write-Host "  1. Review the installation guides above" -ForegroundColor White
    Write-Host "  2. See INSTALL_TOOLS.md for detailed instructions" -ForegroundColor White
    Write-Host "  3. Run this script again after installing tools" -ForegroundColor White
    Write-Host ""
}

# Optional: Write report to file
if ($Detailed) {
    $reportPath = "environment-check-$(Get-Date -Format 'yyyyMMdd-HHmmss').txt"
    $report = @"
Phase IV Environment Check Report
Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')

CPU Cores: $cpu
RAM: ${ramGB}GB
Free Disk: ${freeSpaceGB}GB

Status: $(if ($script:allGood) { "READY" } else { "NEEDS ATTENTION" })

Critical Issues:
$($script:criticalIssues -join "`n")

Warnings:
$($script:warnings -join "`n")
"@

    $report | Out-File -FilePath $reportPath -Encoding UTF8
    Write-Host "Detailed report saved to: $reportPath" -ForegroundColor Gray
}

Write-Host ""

# Exit code
if ($script:allGood) {
    exit 0
} else {
    exit 1
}
