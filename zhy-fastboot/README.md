# fastboot for NinXia(cn-northwest-1) region

All scripts for Kops fast bootstrapping in NinXia(cn-northwest-1) region.

## Usage

1. follow the [README](https://github.com/bnusunny/kops-bjs/blob/master/transparent-proxy/README.md) to build the transparent proxy between NinXia and US. You will need to create two cloudformation stacks - one in U.S. and the other in NinXia.

2. update your [env.config](https://github.com/bnusunny/kops-bjs/blob/master/zhy-fastboot/env.config)

3. update your [create cluster script](https://github.com/bnusunny/kops-bjs/blob/master/zhy-fastboot/create_cluster_localmirror.sh), set your `vpcid` correctly and make sure `--ssh-public-key` points to your local SSH public key path. Update <iam-id> in cluster_name with your IAM user ID.

4. run the create script

   ```bash
    bash create_cluster_localmirror.sh
   ```

   You will see message like this, please ignore it, as we are using an alternative `--kubernetes-version` specified in the `kops create cluster` and kops will consider this as an older version.

   ```bash
   A new kubernetes version is available: 1.9.3

      Upgrading is recommended (try kops upgrade cluster)

      More information: https://github.com/kubernetes/kops/blob/master/permalinks/upgrade_k8s.md#1.9.3

   ```

5. Finally, update your cluster with `—yes`

```bash
 kops update cluster cluster.zhy.k8s.local --yes
```

## Debug

You may ssh into any master node with `ssh core@IP_ADDRSS` and type `journalctl -f` as root to see the system messages.

```bash
ip-172-31-55-1 core # journalctl  -f
-- Logs begin at Mon 2018-05-07 14:12:03 UTC. --
May 07 14:12:47 ip-172-31-55-1.cn-north-1.compute.internal systemd[870]: Reached target Paths.
May 07 14:12:47 ip-172-31-55-1.cn-north-1.compute.internal systemd[870]: Reached target Sockets.
May 07 14:12:47 ip-172-31-55-1.cn-north-1.compute.internal systemd[870]: Reached target Timers.
May 07 14:12:47 ip-172-31-55-1.cn-north-1.compute.internal systemd[870]: Reached target Basic System.
May 07 14:12:47 ip-172-31-55-1.cn-north-1.compute.internal systemd[1]: Started User Manager for UID 500.
May 07 14:12:47 ip-172-31-55-1.cn-north-1.compute.internal systemd[870]: Reached target Default.
May 07 14:12:47 ip-172-31-55-1.cn-north-1.compute.internal systemd[870]: Startup finished in 39ms.
May 07 14:12:49 ip-172-31-55-1.cn-north-1.compute.internal sudo[884]:     core : TTY=pts/0 ; PWD=/home/core ; USER=root ; COMMAND=/bin/bash
May 07 14:12:49 ip-172-31-55-1.cn-north-1.compute.internal sudo[884]: pam_unix(sudo:session): session opened for user root by core(uid=0)
May 07 14:12:49 ip-172-31-55-1.cn-north-1.compute.internal sudo[884]: pam_systemd(sudo:session): Cannot create session: Already running in a session
May 07 14:13:10 ip-172-31-55-1.cn-north-1.compute.internal update_engine[725]: I0507 14:13:10.124577   725 update_attempter.cc:493] Updating boot flags...
```

(You should be able to see the message keeps flowing)

When all the three master nodes under `ELB` become healthy, you may access your cluster with `kubectl`. Typically it would take `5-8` minutes to become all healthy.
