# using the latest Red Hat Universal Base Image 8 Minimal
FROM registry.access.redhat.com/ubi8/ubi-minimal:latest

# setup microsoft rpm package repo and install powershell
RUN rpm --import https://packages.microsoft.com/keys/microsoft.asc \
  && curl https://packages.microsoft.com/config/rhel/7/prod.repo | tee /etc/yum.repos.d/microsoft.repo \
  && microdnf install -y powershell \
  && microdnf clean all

# copy powershell scripts into container
COPY *.ps1 /

ENTRYPOINT ["pwsh", "/Start-Battlesnake.ps1"]
