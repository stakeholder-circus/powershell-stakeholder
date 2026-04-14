FROM alpine:3.20
LABEL org.opencontainers.image.title="powershell-stakeholder"
LABEL org.opencontainers.image.description="Scaffold-only placeholder container for powershell-stakeholder"
CMD ["sh", "-lc", "echo 'powershell-stakeholder scaffold-only baseline';"]
