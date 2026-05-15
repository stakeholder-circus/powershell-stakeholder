FROM mcr.microsoft.com/powershell:7.5-alpine-3.20
WORKDIR /app
COPY bin ./bin
ENTRYPOINT ["pwsh", "-NoLogo", "-NoProfile", "-File", "/app/bin/powershell-stakeholder.ps1"]
