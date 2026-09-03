---
customization:
  systemExtensions:
    officialExtensions:
{{- range .Node.Data.systemExtensions }}
      - {{ . }}
{{- end }}

  extraKernelArgs:
    - intel_iommu=on
    - iommu=pt
    - mitigations=off
    - net.ifnames=1

    - -init_on_alloc          # Less security, faster puter
    - -init_on_free           # Less security, faster puter
    - -selinux                # Less security, faster puter
    - apparmor=0              # Less security, faster puter
    - init_on_alloc=0         # Less security, faster puter
    - init_on_free=0          # Less security, faster puter
    - security=none           # Less security, faster puter
    - talos.auditd.disabled=1 # Less security, faster puter

    # mitigate dirty frag, CVE-2026-43284 & CVE-2026-43500
    # https://github.com/V4bel/dirtyfrag
    - module_blacklist=esp4,esp6,rxrpc
