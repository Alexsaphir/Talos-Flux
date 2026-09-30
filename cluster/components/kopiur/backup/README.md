## Variables

| Name                  | Default         | Description |
| --------------------- | --------------- | ----------- |
| **PVC_NAME**          |                 |             |
| `KOPIUR_CAPACITY`     | `5Gi`           |             |
| `KOPIUR_STORAGECLASS` | `ceph-block`    |             |
| `KOPIUR_ACCESSMODES`  | `ReadWriteOnce` |             |

| Name                          | Default                                | Description                  |
| ----------------------------- | -------------------------------------- | ---------------------------- |
| `KOPIUR_COPYMETHOD`           | `Snapshot`                             |                              |
| `KOPIUR_SNAPSHOTCLASS`        | `csi-ceph-blockpool`                   | `snapshot.storage.k8s.io/v1` |
| `KOPIUR_CACHE_CAPACITY`       | `5Gi`                                  |                              |
| `KOPIUR_STAGING_STORAGECLASS` | `${KOPIUR_STORAGECLASS:=ceph-block}`   |                              |
| `KOPIUR_STAGING_ACCESSMODES`  | `${KOPIUR_ACCESSMODES:=ReadWriteOnce}` |                              |
| `KOPIUR_CACHE_STORAGECLASS`   | `openebs-hostpath`                     |                              |
| `KOPIUR_CACHE_CONTENT_MB`     | `1024`                                 |                              |
| `KOPIUR_CACHE_METADATA_MB`    | `512`                                  |                              |

| Name          | Default | Description |
| ------------- | ------- | ----------- |
| `KOPIUR_PUID` | `1000`  |             |
| `KOPIUR_PGID` | `1000`  |             |

## immich

```yaml
apiVersion: kustomize.toolkit.fluxcd.io/v1
kind: Kustomization
metadata:
  name: &app _
# noinspection KubernetesMissingKeys
spec:
  postBuild:
    substitute:
      PVC_NAME: *app

      KOPIUR_CAPACITY: 300Gi
      KOPIUR_STORAGECLASS: ceph-filesystem
      KOPIUR_ACCESSMODES: ReadWriteMany

      KOPIUR_SNAPSHOTCLASS: csi-ceph-filesystem
      KOPIUR_STAGING_STORAGECLASS: csi-ceph-filesystem-backingsnapshot
      KOPIUR_STAGING_ACCESSMODES: ReadOnlyMany
```
