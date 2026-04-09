param(
  [ValidateSet("plan", "apply", "destroy")]
  [string]$Action = "apply",

  [switch]$AutoApprove,

  [string]$NetworkDir = "piaca-infra/network",
  [string]$Ec2Dir = "piaca-infra/ec2",

  [string]$Ec2VarFile = "all-envs.tfvars"
)

$ErrorActionPreference = "Stop"

function Invoke-Step {
  param(
    [Parameter(Mandatory = $true)]
    [string]$Name,

    [Parameter(Mandatory = $true)]
    [string]$Path,

    [Parameter(Mandatory = $true)]
    [string]$TfAction,

    [string]$VarFile = ""
  )

  if (-not (Test-Path $Path)) {
    throw "Pasta nao encontrada para ${Name}: ${Path}"
  }

  Write-Host ""
  Write-Host "=== $Name ($TfAction) ===" -ForegroundColor Cyan

  Push-Location $Path
  try {
    Write-Host "[terraform] init em $Path" -ForegroundColor Yellow
    terraform init -input=false
    if ($LASTEXITCODE -ne 0) {
      throw "terraform init falhou em $Path"
    }

    $args = @($TfAction)

    if ($VarFile -ne "") {
      if (-not (Test-Path $VarFile)) {
        throw "Arquivo de variaveis nao encontrado em ${Path}: ${VarFile}"
      }
      $args += "-var-file=$VarFile"
    }

    if (($TfAction -eq "apply" -or $TfAction -eq "destroy") -and $AutoApprove.IsPresent) {
      $args += "-auto-approve"
    }

    Write-Host "[terraform] $($args -join ' ')" -ForegroundColor Yellow
    terraform @args
    if ($LASTEXITCODE -ne 0) {
      throw "terraform $TfAction falhou em $Path"
    }
  }
  finally {
    Pop-Location
  }
}

$repoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$networkPath = Join-Path $repoRoot $NetworkDir
$ec2Path = Join-Path $repoRoot $Ec2Dir

Write-Host "Repositorio: $repoRoot" -ForegroundColor Green
Write-Host "Acao: $Action" -ForegroundColor Green

if ($Action -eq "destroy") {
  # Destruicao em ordem inversa para evitar dependencia quebrada.
  Invoke-Step -Name "EC2" -Path $ec2Path -TfAction $Action -VarFile $Ec2VarFile
  Invoke-Step -Name "Network" -Path $networkPath -TfAction $Action
}
else {
  Invoke-Step -Name "Network" -Path $networkPath -TfAction $Action
  Invoke-Step -Name "EC2" -Path $ec2Path -TfAction $Action -VarFile $Ec2VarFile
}

Write-Host "" 
Write-Host "Concluido com sucesso." -ForegroundColor Green
