## Variables

| Name                    | Default              | Description                  |
| ----------------------- | -------------------- | ---------------------------- |
| **PVC_NAME**            |                      |                              |
| `VOLSYNC_CAPACITY`      | `5Gi`                |                              |
| `VOLSYNC_STORAGECLASS`  | `ceph-block`         |                              |
| `VOLSYNC_SNAPSHOTCLASS` | `csi-ceph-blockpool` | `snapshot.storage.k8s.io/v1` |
| `VOLSYNC_ACCESSMODES`   | `ReadWriteOnce`      |                              |

| Name                       | Default         | Description |
| -------------------------- | --------------- | ----------- |
| `VOLSYNC_SNAP_ACCESSMODES` | `ReadWriteOnce` |             |

| Name           | Default | Description |
| -------------- | ------- | ----------- |
| `VOLSYNC_PUID` | `1000`  |             |
| `VOLSYNC_PGID` | `1000`  |             |
| `VOLSYNC_PGID` | `1000`  |             |
