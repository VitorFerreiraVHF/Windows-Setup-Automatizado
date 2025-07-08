# Windows Setup Automatizado

Este repositório contém um script PowerShell genérico para automatizar a configuração inicial de ambientes Windows para diferentes perfis profissionais. Ele automatiza:

- Instalação automática do [winget](https://learn.microsoft.com/pt-br/windows/package-manager/winget/) (caso não esteja presente)
- Instalação de aplicativos essenciais de acordo com o perfil do usuário
- Ativação de recursos do Windows como .NET Framework e IIS (para perfis de desenvolvimento)
- Abertura do Windows Update e Microsoft Store ao final do processo

## Perfis suportados

- **DEVBACK**: Desenvolvedor Back, QA, DevSecOps, Infraestrutura
- **DEVFRONT**: Desenvolvedor Frontend
- **SCRUM**: Scrum, Financeiro, UX/UI

## Como usar

1. **Faça o download do arquivo [`Configuracao.ps1`](./Configuracao.ps1) para o seu computador.**
2. **Execute o PowerShell como Administrador.**
3. **Navegue até a pasta onde salvou o script e execute:**
   ```powershell
   ./Configuracao.ps1
