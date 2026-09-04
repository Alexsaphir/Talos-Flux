{{ range $index, $mac := .Node.Data.bondMembers }}
---
apiVersion: v1alpha1
kind: LinkAliasConfig
name: bond0-m{{ $index }}
selector:
  match: glob("{{ $mac }}", mac(link.permanent_addr))
{{ end }}

---
apiVersion: v1alpha1
kind: BondConfig
name: bond0
links:
{{- range $index, $mac := .Node.Data.bondMembers }}
  - bond0-m{{ $index }}
{{- end }}
bondMode: 802.3ad
lacpRate: fast
xmitHashPolicy: layer3+4
miimon: 100
updelay: 200
downdelay: 200
mtu: 9000

---
apiVersion: v1alpha1
kind: DHCPv4Config
name: bond0
