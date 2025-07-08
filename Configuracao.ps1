#configuracao_padrao.ps1
# Script genérico para configuração de máquina Windows para diferentes perfis

function Install-Winget {
    Write-Host "O winget não está instalado. Iniciando instalação..." -ForegroundColor Yellow

    # Baixar o instalador do App Installer diretamente da Microsoft
    $uri = "https://aka.ms/getwinget"
    $tempFile = "$env:TEMP\AppInstaller.msixbundle"
    Invoke-WebRequest -Uri $uri -OutFile $tempFile

    # Instalar o pacote (requer permissões de administrador)
    try {
        Add-AppxPackage -Path $tempFile
        Write-Host "O winget foi instalado com sucesso."
    } catch {
        Write-Host "Falha ao instalar o winget. Instale manualmente pela Microsoft Store." -ForegroundColor Red
    }

    # Orientar e encerrar o script
    Write-Host ""
    Write-Host "Por favor, FECHE e execute novamente este script para continuar a configuração." -ForegroundColor Cyan
    Pause
    Exit
}

# Passo 1: Verifica se o winget está instalado
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Install-Winget
}

Clear-Host
Write-Host "******************************************"
Write-Host "******** Padroes de Configuracao *********"
Write-Host "******************************************"
Write-Host ""
Write-Host "Considere as opcoes abaixo:"
Write-Host "**********************************************"
Write-Host "(DEVBACK)  - Para 'Desenvolvedor Back', 'QA', 'DevSecOps' e 'Infra'"
Write-Host "(DEVFRONT) - Para 'Desenvolvedor Front'"
Write-Host "(SCRUM)    - Para 'Scrum', 'Financeiro' e 'UX e UI'"
Write-Host "**********************************************"
Write-Host ""

# Função para garantir entrada válida
function Get-UserRole {
    param(
        [string[]]$validRoles = @("DEVBACK", "DEVFRONT", "SCRUM")
    )
    while ($true) {
        $role = Read-Host "Digite qual será a função do usuário (DEVBACK/DEVFRONT/SCRUM ou S para sair)"
        if ($role -eq "S") { exit }
        $role = $role.ToUpper().Trim()
        if ($validRoles -contains $role) { return $role }
        Write-Host "Opção inválida. Tente novamente." -ForegroundColor Red
    }
}

$FuncaoUsuario = Get-UserRole
Write-Host "Função escolhida: $FuncaoUsuario"
Write-Host ""

# Função para instalar programas via winget
function Install-App {
    param([string]$AppId)
    Write-Host "Instalando $AppId..."
    winget install --id=$AppId --silent --accept-package-agreements --accept-source-agreements
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Sucesso ao instalar $AppId" -ForegroundColor Green
    } else {
        Write-Host "Falha ao instalar $AppId" -ForegroundColor Red
    }
    Write-Host ""
}

Write-Host "**********************************************"
Write-Host "* Passo 1 Instalando apps padrão por função  *"
Write-Host "**********************************************"
Write-Host ""

if ($FuncaoUsuario -eq "DEVBACK") {
    Install-App "Notepad++.Notepad++"
    Install-App "Postman.Postman"
    Install-App "XP9KHM4BK9FZ7Q"
    Install-App "ScooterSoftware.BeyondCompare.4"
    Install-App "Microsoft.SQLServerManagementStudio"
    # Install-App "Microsoft.VisualStudio.2022.Professional"
}
elseif ($FuncaoUsuario -eq "DEVFRONT") {
    Install-App "Notepad++.Notepad++"
    Install-App "XP9KHM4BK9FZ7Q"
    Install-App "Postman.Postman"
    Install-App "Microsoft.SQLServerManagementStudio"
}
elseif ($FuncaoUsuario -eq "SCRUM") {
    Install-App "Notepad++.Notepad++"
}

# Recursos do Windows só para DEVBACK e DEVFRONT
if ($FuncaoUsuario -eq "DEVBACK" -or $FuncaoUsuario -eq "DEVFRONT") {
    Write-Host "**********************************************"
    Write-Host "Ativando recursos do Windows (.NET, IIS)"
    Write-Host "**********************************************"
    # .NET Framework 3.5 (inclui 2.0 e 3.0)
    Enable-WindowsOptionalFeature -Online -FeatureName "NetFx3" -All -NoRestart
    # .NET Framework 4.8 Advanced Services
    Enable-WindowsOptionalFeature -Online -FeatureName "NetFx4-AdvSrvs" -All -NoRestart
    Enable-WindowsOptionalFeature -Online -FeatureName "NetFx4Extended-ASPNET" -All -NoRestart
    # IIS completo
    Enable-WindowsOptionalFeature -Online -FeatureName "IIS-WebServerRole" -All -NoRestart
    # Adicione mais recursos do IIS se necessário
}

Write-Host "**********************************************"
Write-Host "Passo 2 Instalando apps padrão não específicos"
Write-Host "**********************************************"
Install-App "Mozilla.Firefox.ESR"
Install-App "Google.Chrome"
Install-App "7zip.7zip"
Install-App "9WZDNCRD29V9"
Install-App "Oracle.JavaRuntimeEnvironment"
Install-App "Adobe.Acrobat.Reader.64-bit"
Install-App "Fortinet.FortiClientVPN"

Write-Host "**********************************************"
Write-Host "Configurações de Sistema Operacional"
Write-Host "**********************************************"
# Adicione comandos extras aqui

Write-Host ""
Write-Host "Script finalizado!" -ForegroundColor Cyan
Write-Host "Abrindo Windows Update e Microsoft Store..."

Start-Process "ms-settings:windowsupdate"
Start-Process "ms-windows-store:"

Pause