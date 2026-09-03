# Talos Patching

<https://www.talos.dev/v1.13/talos-guides/configuration/patching/>

Strategic merge patches applied on top of the machine config TOPF generates from
[`../topf.yaml`](../topf.yaml) (`patchesDir: topf-patches`).

## Layout

TOPF walks these directories in order and appends every patch document it finds.
Files sort lexicographically inside each directory, hence the two-digit prefixes.

- `all/`: applied to every node
- `control-plane/`: applied to control-plane nodes only
- `worker/`: applied to worker nodes only (unused — the cluster is control-plane only)
- `node/${hostname}/`: applied to a single node

## File types

- `*.yaml` / `*.yml`: plain patches, SOPS-decrypted if encrypted
- `*.yaml.tpl` / `*.yml.tpl`: rendered as Go templates first

Templates get `.ClusterName`, `.ClusterEndpoint`, `.KubernetesVersion`,
`.TalosVersion`, `.SchematicID`, `.Data.*` (from `topf.yaml`), `.Node.*`
(`.Host`, `.IP`, `.Role`, `.Data.*`) and the
[sprig](https://masterminds.github.io/sprig/) function library. Missing keys are
a hard error.

## Notes

- A single file may hold several `---`-separated documents, including the
    standalone Talos config kinds (`VolumeConfig`, `ExtensionServiceConfig`, …).
- Only strategic merge patches are supported. Use `$patch: delete` to remove a
    field; RFC 6902 (`op: remove`) patches are rejected.
