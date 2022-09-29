---
# Source: cilium/templates/cilium-agent/serviceaccount.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: "cilium"
  namespace: kube-system
---
# Source: cilium/templates/cilium-operator/serviceaccount.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: "cilium-operator"
  namespace: kube-system
---
# Source: cilium/templates/hubble-relay/serviceaccount.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: "hubble-relay"
  namespace: kube-system
---
# Source: cilium/templates/hubble/tls-cronjob/serviceaccount.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: "hubble-generate-certs"
  namespace: kube-system
---
# Source: cilium/templates/cilium-configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: cilium-config
  namespace: kube-system
data:

  # Identity allocation mode selects how identities are shared between cilium
  # nodes by setting how they are stored. The options are "crd" or "kvstore".
  # - "crd" stores identities in kubernetes as CRDs (custom resource definition).
  #   These can be queried with:
  #     kubectl get ciliumid
  # - "kvstore" stores identities in an etcd kvstore, that is
  #   configured below. Cilium versions before 1.6 supported only the kvstore
  #   backend. Upgrades from these older cilium versions should continue using
  #   the kvstore by commenting out the identity-allocation-mode below, or
  #   setting it to "kvstore".
  identity-allocation-mode: crd
  cilium-endpoint-gc-interval: "5m0s"
  nodes-gc-interval: "5m0s"
  # Disable the usage of CiliumEndpoint CRD
  disable-endpoint-crd: "false"

  # If you want to run cilium in debug mode change this value to true
  debug: "true"
  # The agent can be put into the following three policy enforcement modes
  # default, always and never.
  # https://docs.cilium.io/en/latest/policy/intro/#policy-enforcement-modes
  enable-policy: "default"
  # If you want metrics enabled in all of your Cilium agents, set the port for
  # which the Cilium agents will have their metrics exposed.
  # This option deprecates the "prometheus-serve-addr" in the
  # "cilium-metrics-config" ConfigMap
  # NOTE that this will open the port on ALL nodes where Cilium pods are
  # scheduled.
  prometheus-serve-addr: ":9090"
  # Port to expose Envoy metrics (e.g. "9095"). Envoy metrics listener will be disabled if this
  # field is not set.
  # If you want metrics enabled in cilium-operator, set the port for
  # which the Cilium Operator will have their metrics exposed.
  # NOTE that this will open the port on the nodes where Cilium operator pod
  # is scheduled.
  operator-prometheus-serve-addr: ":6942"
  enable-metrics: "true"

  # Enable IPv4 addressing. If enabled, all endpoints are allocated an IPv4
  # address.
  enable-ipv4: "true"

  # Enable IPv6 addressing. If enabled, all endpoints are allocated an IPv6
  # address.
  enable-ipv6: "false"
  # Users who wish to specify their own custom CNI configuration file must set
  # custom-cni-conf to "true", otherwise Cilium may overwrite the configuration.
  custom-cni-conf: "false"
  enable-bpf-clock-probe: "true"
  # If you want cilium monitor to aggregate tracing for packets, set this level
  # to "low", "medium", or "maximum". The higher the level, the less packets
  # that will be seen in monitor output.
  monitor-aggregation: medium

  # The monitor aggregation interval governs the typical time between monitor
  # notification events for each allowed connection.
  #
  # Only effective when monitor aggregation is set to "medium" or higher.
  monitor-aggregation-interval: 5s

  # The monitor aggregation flags determine which TCP flags which, upon the
  # first observation, cause monitor notifications to be generated.
  #
  # Only effective when monitor aggregation is set to "medium" or higher.
  monitor-aggregation-flags: all
  # Specifies the ratio (0.0-1.0) of total system memory to use for dynamic
  # sizing of the TCP CT, non-TCP CT, NAT and policy BPF maps.
  bpf-map-dynamic-size-ratio: "0.0025"
  # bpf-policy-map-max specifies the maximum number of entries in endpoint
  # policy map (per endpoint)
  bpf-policy-map-max: "16384"
  # bpf-lb-map-max specifies the maximum number of entries in bpf lb service,
  # backend and affinity maps.
  bpf-lb-map-max: "65536"
  # bpf-lb-bypass-fib-lookup instructs Cilium to enable the FIB lookup bypass
  # optimization for nodeport reverse NAT handling.
  bpf-lb-external-clusterip: "false"

  # Pre-allocation of map entries allows per-packet latency to be reduced, at
  # the expense of up-front memory allocation for the entries in the maps. The
  # default value below will minimize memory usage in the default installation;
  # users who are sensitive to latency may consider setting this to "true".
  #
  # This option was introduced in Cilium 1.4. Cilium 1.3 and earlier ignore
  # this option and behave as though it is set to "true".
  #
  # If this value is modified, then during the next Cilium startup the restore
  # of existing endpoints and tracking of ongoing connections may be disrupted.
  # As a result, reply packets may be dropped and the load-balancing decisions
  # for established connections may change.
  #
  # If this option is set to "false" during an upgrade from 1.3 or earlier to
  # 1.4 or later, then it may cause one-time disruptions during the upgrade.
  preallocate-bpf-maps: "false"

  # Regular expression matching compatible Istio sidecar istio-proxy
  # container image names
  sidecar-istio-proxy-image: "cilium/istio_proxy"

  # Name of the cluster. Only relevant when building a mesh of clusters.
  cluster-name: default

  # Encapsulation mode for communication between nodes
  # Possible values:
  #   - disabled
  #   - vxlan (default)
  #   - geneve
  tunnel: "vxlan"
  # Enables L7 proxy for L7 policy enforcement and visibility
  enable-l7-proxy: "true"

  enable-ipv4-masquerade: "true"
  enable-ipv6-masquerade: "false"
  enable-bpf-masquerade: "false"

  enable-xt-socket-fallback: "true"
  install-iptables-rules: "true"
  install-no-conntrack-iptables-rules: "false"

  auto-direct-node-routes: "false"
  enable-bandwidth-manager: "false"
  enable-local-redirect-policy: "false"

  kube-proxy-replacement:  "strict"
  kube-proxy-replacement-healthz-bind-address: ""
  enable-health-check-nodeport: "true"
  node-port-bind-protection: "true"
  enable-auto-protect-node-port-range: "true"
  enable-session-affinity: "true"
  enable-l2-neigh-discovery: "true"
  arping-refresh-period: "30s"
  enable-endpoint-health-checking: "true"
  enable-health-checking: "true"
  enable-well-known-identities: "false"
  enable-remote-node-identity: "true"
  operator-api-serve-addr: "127.0.0.1:9234"
  # Enable Hubble gRPC service.
  enable-hubble: "true"
  # UNIX domain socket for Hubble server to listen to.
  hubble-socket-path:  "/var/run/cilium/hubble.sock"
  # An additional address for Hubble server to listen to (e.g. ":4244").
  hubble-listen-address: ":4244"
  hubble-disable-tls: "false"
  hubble-tls-cert-file: /var/lib/cilium/tls/hubble/server.crt
  hubble-tls-key-file: /var/lib/cilium/tls/hubble/server.key
  hubble-tls-client-ca-files: /var/lib/cilium/tls/hubble/client-ca.crt
  ipam: "cluster-pool"
  cluster-pool-ipv4-cidr: "${cluster_cidr}"
  cluster-pool-ipv4-mask-size: "${cluster_mask_size}"
  disable-cnp-status-updates: "true"
  cgroup-root: "/run/cilium/cgroupv2"
  enable-k8s-terminating-endpoint: "true"
  annotate-k8s-node: "true"
  remove-cilium-node-taints: "true"
  set-cilium-is-up-condition: "true"
  unmanaged-pod-watcher-interval: "15"
  agent-not-ready-taint-key: "node.cilium.io/agent-not-ready"
---
# Source: cilium/templates/hubble-relay/configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: hubble-relay-config
  namespace: kube-system
data:
  config.yaml: |
    cluster-name: default
    peer-service: "hubble-peer.kube-system.svc.cluster.local:443"
    listen-address: :4245
    dial-timeout: 
    retry-timeout: 
    sort-buffer-len-max: 
    sort-buffer-drain-timeout: 
    tls-client-cert-file: /var/lib/hubble-relay/tls/client.crt
    tls-client-key-file: /var/lib/hubble-relay/tls/client.key
    tls-hubble-server-ca-files: /var/lib/hubble-relay/tls/hubble-server-ca.crt
    disable-server-tls: true
---
# Source: cilium/templates/cilium-agent/clusterrole.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: cilium
rules:
- apiGroups:
  - networking.k8s.io
  resources:
  - networkpolicies
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - discovery.k8s.io
  resources:
  - endpointslices
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - ""
  resources:
  - namespaces
  - services
  - pods
  - endpoints
  - nodes
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - ""
  resources:
  - nodes/status
  verbs:
  # To annotate the k8s node with Cilium's metadata
  - patch
- apiGroups:
  - apiextensions.k8s.io
  resources:
  - customresourcedefinitions
  verbs:
  # Deprecated for removal in v1.10
  - create
  - list
  - watch
  - update

  # This is used when validating policies in preflight. This will need to stay
  # until we figure out how to avoid "get" inside the preflight, and then
  # should be removed ideally.
  - get
- apiGroups:
  - cilium.io
  resources:
  - ciliumnetworkpolicies
  - ciliumnetworkpolicies/status
  - ciliumclusterwidenetworkpolicies
  - ciliumclusterwidenetworkpolicies/status
  - ciliumendpoints
  - ciliumendpoints/status
  - ciliumnodes
  - ciliumnodes/status
  - ciliumidentities
  - ciliumlocalredirectpolicies
  - ciliumlocalredirectpolicies/status
  - ciliumegressnatpolicies
  - ciliumendpointslices
  verbs:
  - '*'
---
# Source: cilium/templates/cilium-operator/clusterrole.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: cilium-operator
rules:
- apiGroups:
  - ""
  resources:
  - pods
  verbs:
  - get
  - list
  - watch
  # to automatically delete [core|kube]dns pods so that are starting to being
  # managed by Cilium
  - delete
- apiGroups:
  - ""
  resources:
  - nodes
  verbs:
  - list
  - watch
- apiGroups:
  - ""
  resources:
  # To remove node taints
  - nodes
  # To set NetworkUnavailable false on startup
  - nodes/status
  verbs:
  - patch
- apiGroups:
  - discovery.k8s.io
  resources:
  - endpointslices
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - ""
  resources:
  - services
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - ""
  resources:
  # to perform LB IP allocation for BGP
  - services/status
  verbs:
  - update
- apiGroups:
  - ""
  resources:
  # to perform the translation of a CNP that contains `ToGroup` to its endpoints
  - services
  - endpoints
  # to check apiserver connectivity
  - namespaces
  verbs:
  - get
  - list
  - watch
- apiGroups:
  - cilium.io
  resources:
  - ciliumnetworkpolicies
  - ciliumnetworkpolicies/status
  - ciliumnetworkpolicies/finalizers
  - ciliumclusterwidenetworkpolicies
  - ciliumclusterwidenetworkpolicies/status
  - ciliumclusterwidenetworkpolicies/finalizers
  - ciliumendpoints
  - ciliumendpoints/status
  - ciliumendpoints/finalizers
  - ciliumnodes
  - ciliumnodes/status
  - ciliumnodes/finalizers
  - ciliumidentities
  - ciliumendpointslices
  - ciliumidentities/status
  - ciliumidentities/finalizers
  - ciliumlocalredirectpolicies
  - ciliumlocalredirectpolicies/status
  - ciliumlocalredirectpolicies/finalizers
  verbs:
  - '*'
- apiGroups:
  - apiextensions.k8s.io
  resources:
  - customresourcedefinitions
  verbs:
  - create
  - get
  - list
  - update
  - watch
# For cilium-operator running in HA mode.
#
# Cilium operator running in HA mode requires the use of ResourceLock for Leader Election
# between multiple running instances.
# The preferred way of doing this is to use LeasesResourceLock as edits to Leases are less
# common and fewer objects in the cluster watch "all Leases".
- apiGroups:
  - coordination.k8s.io
  resources:
  - leases
  verbs:
  - create
  - get
  - update
---
# Source: cilium/templates/hubble/tls-cronjob/clusterrole.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: hubble-generate-certs
rules:
  - apiGroups:
      - ""
    resources:
      - secrets
    verbs:
      - create
  - apiGroups:
      - ""
    resources:
      - secrets
    resourceNames:
      - hubble-server-certs
      - hubble-relay-client-certs
      - hubble-relay-server-certs
    verbs:
      - update
  - apiGroups:
      - ""
    resources:
      - secrets
    resourceNames:
      - hubble-ca-secret
    verbs:
      - get
      - update
---
# Source: cilium/templates/cilium-agent/clusterrolebinding.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: cilium
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cilium
subjects:
- kind: ServiceAccount
  name: "cilium"
  namespace: kube-system
---
# Source: cilium/templates/cilium-operator/clusterrolebinding.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: cilium-operator
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cilium-operator
subjects:
- kind: ServiceAccount
  name: "cilium-operator"
  namespace: kube-system
---
# Source: cilium/templates/hubble/tls-cronjob/clusterrolebinding.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: hubble-generate-certs
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: hubble-generate-certs
subjects:
- kind: ServiceAccount
  name: "hubble-generate-certs"
  namespace: kube-system
---
# Source: cilium/templates/hubble-relay/service.yaml
kind: Service
apiVersion: v1
metadata:
  name: hubble-relay
  namespace: kube-system
  labels:
    k8s-app: hubble-relay
spec:
  type: ClusterIP
  selector:
    k8s-app: hubble-relay
  ports:
  - protocol: TCP
    port: 80
    targetPort: 4245
---
# Source: cilium/templates/hubble/peer-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: hubble-peer
  namespace: kube-system
  labels:
    k8s-app: cilium
spec:
  selector:
    k8s-app: cilium
  ports:
  - name: peer-service
    port: 443
    protocol: TCP
    targetPort: 4244
---
# Source: cilium/templates/cilium-agent/daemonset.yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: cilium
  namespace: kube-system
  labels:
    k8s-app: cilium
spec:
  selector:
    matchLabels:
      k8s-app: cilium
  updateStrategy:
    rollingUpdate:
      maxUnavailable: 2
    type: RollingUpdate
  template:
    metadata:
      annotations:
        prometheus.io/port: "9090"
        prometheus.io/scrape: "true"
        # ensure pods roll when configmap updates
        cilium.io/cilium-configmap-checksum: "1c5375edc6821fa24e0927b2696cb40ba7026a59f28985d55a1da06bf4e941dc"
      labels:
        k8s-app: cilium
    spec:
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
              - key: kubernetes.io/os
                operator: In
                values:
                - linux
            - matchExpressions:
              - key: beta.kubernetes.io/os
                operator: In
                values:
                - linux
        podAntiAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
          - labelSelector:
              matchExpressions:
              - key: k8s-app
                operator: In
                values:
                - cilium
            topologyKey: kubernetes.io/hostname
      containers:
      - name: cilium-agent
        image: "${agent_repo}:${agent_tag}"
        imagePullPolicy: IfNotPresent
        command:
        - cilium-agent
        args:
        - --config-dir=/tmp/cilium/config-map
        startupProbe:
          httpGet:
            host: "127.0.0.1"
            path: /healthz
            port: 9879
            scheme: HTTP
            httpHeaders:
            - name: "brief"
              value: "true"
          failureThreshold: 105
          periodSeconds: 2
          successThreshold: 1
        livenessProbe:
          httpGet:
            host: "127.0.0.1"
            path: /healthz
            port: 9879
            scheme: HTTP
            httpHeaders:
            - name: "brief"
              value: "true"
          periodSeconds: 30
          successThreshold: 1
          failureThreshold: 10
          timeoutSeconds: 5
        readinessProbe:
          httpGet:
            host: "127.0.0.1"
            path: /healthz
            port: 9879
            scheme: HTTP
            httpHeaders:
            - name: "brief"
              value: "true"
          periodSeconds: 30
          successThreshold: 1
          failureThreshold: 3
          timeoutSeconds: 5
        env:
        - name: K8S_NODE_NAME
          valueFrom:
            fieldRef:
              apiVersion: v1
              fieldPath: spec.nodeName
        - name: CILIUM_K8S_NAMESPACE
          valueFrom:
            fieldRef:
              apiVersion: v1
              fieldPath: metadata.namespace
        - name: CILIUM_CLUSTERMESH_CONFIG
          value: /var/lib/cilium/clustermesh/
        - name: CILIUM_CNI_CHAINING_MODE
          valueFrom:
            configMapKeyRef:
              name: cilium-config
              key: cni-chaining-mode
              optional: true
        - name: CILIUM_CUSTOM_CNI_CONF
          valueFrom:
            configMapKeyRef:
              name: cilium-config
              key: custom-cni-conf
              optional: true
        - name: KUBERNETES_SERVICE_HOST
          value: "${apiserver_host}"
        - name: KUBERNETES_SERVICE_PORT
          value: "${apiserver_port}"
        lifecycle:
          postStart:
            exec:
              command:
              - "/cni-install.sh"
              - "--enable-debug=true"
              - "--cni-exclusive=true"
          preStop:
            exec:
              command:
              - /cni-uninstall.sh
        resources:
          requests:
            cpu: 100m
            memory: 512Mi
        ports:
        - name: peer-service
          containerPort: 4244
          hostPort: 4244
          protocol: TCP
        - name: prometheus
          containerPort: 9090
          hostPort: 9090
          protocol: TCP
        securityContext:
          privileged: true
        volumeMounts:
        - name: bpf-maps
          mountPath: /sys/fs/bpf
          mountPropagation: Bidirectional
        - name: cilium-run
          mountPath: /var/run/cilium
        - name: cni-path
          mountPath: /host/opt/cni/bin
        - name: etc-cni-netd
          mountPath: /host/etc/cni/net.d
        - name: clustermesh-secrets
          mountPath: /var/lib/cilium/clustermesh
          readOnly: true
        - name: cilium-config-path
          mountPath: /tmp/cilium/config-map
          readOnly: true
          # Needed to be able to load kernel modules
        - name: lib-modules
          mountPath: /lib/modules
          readOnly: true
        - name: xtables-lock
          mountPath: /run/xtables.lock
        - name: hubble-tls
          mountPath: /var/lib/cilium/tls/hubble
          readOnly: true
      hostNetwork: true
      initContainers:
      # Required to mount cgroup2 filesystem on the underlying Kubernetes node.
      # We use nsenter command with host's cgroup and mount namespaces enabled.
      - name: mount-cgroup
        image: "${agent_repo}:${agent_tag}"
        imagePullPolicy: IfNotPresent
        env:
        - name: CGROUP_ROOT
          value: /run/cilium/cgroupv2
        - name: BIN_PATH
          value: /opt/cni/bin
        command:
        - sh
        - -ec
        # The statically linked Go program binary is invoked to avoid any
        # dependency on utilities like sh and mount that can be missing on certain
        # distros installed on the underlying host. Copy the binary to the
        # same directory where we install cilium cni plugin so that exec permissions
        # are available.
        - |
          cp /usr/bin/cilium-mount /hostbin/cilium-mount;
          nsenter --cgroup=/hostproc/1/ns/cgroup --mount=/hostproc/1/ns/mnt "$BIN_PATH/cilium-mount" $CGROUP_ROOT;
          rm /hostbin/cilium-mount
        volumeMounts:
        - name: hostproc
          mountPath: /hostproc
        - name: cni-path
          mountPath: /hostbin
        securityContext:
          privileged: true
      - name: apply-sysctl-overwrites
        image: "${agent_repo}:${agent_tag}"
        imagePullPolicy: IfNotPresent
        env:
        - name: BIN_PATH
          value: /opt/cni/bin
        command:
        - sh
        - -ec
        # The statically linked Go program binary is invoked to avoid any
        # dependency on utilities like sh that can be missing on certain
        # distros installed on the underlying host. Copy the binary to the
        # same directory where we install cilium cni plugin so that exec permissions
        # are available.
        - |
          cp /usr/bin/cilium-sysctlfix /hostbin/cilium-sysctlfix;
          nsenter --mount=/hostproc/1/ns/mnt "$BIN_PATH/cilium-sysctlfix";
          rm /hostbin/cilium-sysctlfix
        volumeMounts:
        - name: hostproc
          mountPath: /hostproc
        - name: cni-path
          mountPath: /hostbin
        securityContext:
          privileged: true
      - name: clean-cilium-state
        image: "${agent_repo}:${agent_tag}"
        imagePullPolicy: IfNotPresent
        command:
        - /init-container.sh
        env:
        - name: CILIUM_ALL_STATE
          valueFrom:
            configMapKeyRef:
              name: cilium-config
              key: clean-cilium-state
              optional: true
        - name: CILIUM_BPF_STATE
          valueFrom:
            configMapKeyRef:
              name: cilium-config
              key: clean-cilium-bpf-state
              optional: true
        - name: KUBERNETES_SERVICE_HOST
          value: "${apiserver_host}"
        - name: KUBERNETES_SERVICE_PORT
          value: "${apiserver_port}"
        securityContext:
          privileged: true
        volumeMounts:
        - name: bpf-maps
          mountPath: /sys/fs/bpf
          # Required to mount cgroup filesystem from the host to cilium agent pod
        - name: cilium-cgroup
          mountPath: /run/cilium/cgroupv2
          mountPropagation: HostToContainer
        - name: cilium-run
          mountPath: /var/run/cilium
        resources:
          requests:
            cpu: 100m
            memory: 100Mi # wait-for-kube-proxy
      restartPolicy: Always
      priorityClassName: system-node-critical
      serviceAccount: "cilium"
      serviceAccountName: "cilium"
      terminationGracePeriodSeconds: 1
      tolerations:
        - operator: Exists
      volumes:
        # To keep state between restarts / upgrades
      - name: cilium-run
        hostPath:
          path: /var/run/cilium
          type: DirectoryOrCreate
        # To keep state between restarts / upgrades for bpf maps
      - name: bpf-maps
        hostPath:
          path: /sys/fs/bpf
          type: DirectoryOrCreate
      # To mount cgroup2 filesystem on the host
      - name: hostproc
        hostPath:
          path: /proc
          type: Directory
      # To keep state between restarts / upgrades for cgroup2 filesystem
      - name: cilium-cgroup
        hostPath:
          path: /run/cilium/cgroupv2
          type: DirectoryOrCreate
      # To install cilium cni plugin in the host
      - name: cni-path
        hostPath:
          path:  /opt/cni/bin
          type: DirectoryOrCreate
        # To install cilium cni configuration in the host
      - name: etc-cni-netd
        hostPath:
          path: /etc/cni/net.d
          type: DirectoryOrCreate
        # To be able to load kernel modules
      - name: lib-modules
        hostPath:
          path: /lib/modules
        # To access iptables concurrently with other processes (e.g. kube-proxy)
      - name: xtables-lock
        hostPath:
          path: /run/xtables.lock
          type: FileOrCreate
        # To read the clustermesh configuration
      - name: clustermesh-secrets
        secret:
          secretName: cilium-clustermesh
          # note: the leading zero means this number is in octal representation: do not remove it
          defaultMode: 0400
          optional: true
        # To read the configuration from the config map
      - name: cilium-config-path
        configMap:
          name: cilium-config
      - name: hubble-tls
        projected:
          # note: the leading zero means this number is in octal representation: do not remove it
          defaultMode: 0400
          sources:
          - secret:
              name: hubble-server-certs
              optional: true
              items:
              - key: ca.crt
                path: client-ca.crt
              - key: tls.crt
                path: server.crt
              - key: tls.key
                path: server.key
---
# Source: cilium/templates/cilium-operator/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: cilium-operator
  namespace: kube-system
  labels:
    io.cilium/app: operator
    name: cilium-operator
spec:
  # See docs on ServerCapabilities.LeasesResourceLock in file pkg/k8s/version/version.go
  # for more details.
  replicas: 2
  selector:
    matchLabels:
      io.cilium/app: operator
      name: cilium-operator
  strategy:
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 1
    type: RollingUpdate
  template:
    metadata:
      annotations:
        # ensure pods roll when configmap updates
        cilium.io/cilium-configmap-checksum: "1c5375edc6821fa24e0927b2696cb40ba7026a59f28985d55a1da06bf4e941dc"
        prometheus.io/port: "6942"
        prometheus.io/scrape: "true"
      labels:
        io.cilium/app: operator
        name: cilium-operator
    spec:
      # In HA mode, cilium-operator pods must not be scheduled on the same
      # node as they will clash with each other.
      affinity:
        podAntiAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
          - labelSelector:
              matchExpressions:
              - key: io.cilium/app
                operator: In
                values:
                - operator
            topologyKey: kubernetes.io/hostname
      containers:
      - name: cilium-operator
        image: ${operator_repo}-generic:${operator_tag}
        imagePullPolicy: IfNotPresent
        command:
        - cilium-operator-generic
        args:
        - --config-dir=/tmp/cilium/config-map
        - --debug=$(CILIUM_DEBUG)
        env:
        - name: K8S_NODE_NAME
          valueFrom:
            fieldRef:
              apiVersion: v1
              fieldPath: spec.nodeName
        - name: CILIUM_K8S_NAMESPACE
          valueFrom:
            fieldRef:
              apiVersion: v1
              fieldPath: metadata.namespace
        - name: CILIUM_DEBUG
          valueFrom:
            configMapKeyRef:
              key: debug
              name: cilium-config
              optional: true
        - name: KUBERNETES_SERVICE_HOST
          value: "${apiserver_host}"
        - name: KUBERNETES_SERVICE_PORT
          value: "${apiserver_port}"
        ports:
        - name: prometheus
          containerPort: 6942
          hostPort: 6942
          protocol: TCP
        livenessProbe:
          httpGet:
            host: "127.0.0.1"
            path: /healthz
            port: 9234
            scheme: HTTP
          initialDelaySeconds: 60
          periodSeconds: 10
          timeoutSeconds: 3
        volumeMounts:
        - name: cilium-config-path
          mountPath: /tmp/cilium/config-map
          readOnly: true
        resources:
          limits:
            cpu: 1000m
            memory: 1Gi
          requests:
            cpu: 100m
            memory: 128Mi
      hostNetwork: true
      restartPolicy: Always
      priorityClassName: system-cluster-critical
      serviceAccount: "cilium-operator"
      serviceAccountName: "cilium-operator"
      tolerations:
        - operator: Exists
      volumes:
        # To read the configuration from the config map
      - name: cilium-config-path
        configMap:
          name: cilium-config
---
# Source: cilium/templates/hubble-relay/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hubble-relay
  namespace: kube-system
  labels:
    k8s-app: hubble-relay
spec:
  replicas: 1
  selector:
    matchLabels:
      k8s-app: hubble-relay
  strategy:
    rollingUpdate:
      maxUnavailable: 1
    type: RollingUpdate
  template:
    metadata:
      annotations:
      labels:
        k8s-app: hubble-relay
    spec:
      affinity:
        podAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
          - labelSelector:
              matchExpressions:
                - key: "k8s-app"
                  operator: In
                  values:
                    - cilium
            topologyKey: "kubernetes.io/hostname"
      containers:
        - name: hubble-relay
          image: "${hubble_relay_repo}:${hubble_relay_tag}"
          imagePullPolicy: IfNotPresent
          command:
            - hubble-relay
          args:
            - serve
            - --debug
          ports:
            - name: grpc
              containerPort: 4245
          readinessProbe:
            tcpSocket:
              port: grpc
          livenessProbe:
            tcpSocket:
              port: grpc
          resources:
            limits:
              cpu: 1000m
              memory: 1024M
            requests:
              cpu: 100m
              memory: 64Mi
          volumeMounts:
          - name: config
            mountPath: /etc/hubble-relay
            readOnly: true
          - name: tls
            mountPath: /var/lib/hubble-relay/tls
            readOnly: true
      restartPolicy: Always
      priorityClassName: 
      serviceAccount: "hubble-relay"
      serviceAccountName: "hubble-relay"
      automountServiceAccountToken: false
      terminationGracePeriodSeconds: 0
      volumes:
      - name: config
        configMap:
          name: hubble-relay-config
          items:
          - key: config.yaml
            path: config.yaml
      - name: tls
        projected:
          # note: the leading zero means this number is in octal representation: do not remove it
          defaultMode: 0400
          sources:
          - secret:
              name: hubble-relay-client-certs
              items:
                - key: ca.crt
                  path: hubble-server-ca.crt
                - key: tls.crt
                  path: client.crt
                - key: tls.key
                  path: client.key
---
# Source: cilium/templates/hubble/tls-cronjob/job.yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: hubble-generate-certs-44ea24c8e8
  namespace: kube-system
  labels:
    k8s-app: hubble-generate-certs
spec:
  template:
    metadata:
      labels:
        k8s-app: hubble-generate-certs
    spec:
      containers:
        - name: certgen
          image: "${certgen_repo}:${certgen_tag}"
          imagePullPolicy: IfNotPresent
          command:
            - "/usr/bin/cilium-certgen"
          # Because this is executed as a job, we pass the values as command
          # line args instead of via config map. This allows users to inspect
          # the values used in past runs by inspecting the completed pod.
          args:
            - "--cilium-namespace=kube-system"
            - "--debug"
            - "--hubble-ca-generate"
            - "--hubble-ca-reuse-secret"
            - "--hubble-server-cert-generate"
            - "--hubble-server-cert-common-name=*.default.hubble-grpc.cilium.io"
            - "--hubble-server-cert-validity-duration=94608000s"
            - "--hubble-relay-client-cert-generate"
            - "--hubble-relay-client-cert-validity-duration=94608000s"
      hostNetwork: true
      serviceAccount: "hubble-generate-certs"
      serviceAccountName: "hubble-generate-certs"
      restartPolicy: OnFailure
  ttlSecondsAfterFinished: 1800
---
# Source: cilium/templates/hubble/tls-cronjob/cronjob.yaml
apiVersion: batch/v1beta1
kind: CronJob
metadata:
  name: hubble-generate-certs
  namespace: kube-system
  labels:
    k8s-app: hubble-generate-certs
spec:
  schedule: "0 0 1 */4 *"
  concurrencyPolicy: Forbid
  jobTemplate:
    spec:
      template:
        metadata:
          labels:
            k8s-app: hubble-generate-certs
        spec:
          containers:
            - name: certgen
              image: "${certgen_repo}:${certgen_tag}"
              imagePullPolicy: IfNotPresent
              command:
                - "/usr/bin/cilium-certgen"
              # Because this is executed as a job, we pass the values as command
              # line args instead of via config map. This allows users to inspect
              # the values used in past runs by inspecting the completed pod.
              args:
                - "--cilium-namespace=kube-system"
                - "--debug"
                - "--hubble-ca-generate"
                - "--hubble-ca-reuse-secret"
                - "--hubble-server-cert-generate"
                - "--hubble-server-cert-common-name=*.default.hubble-grpc.cilium.io"
                - "--hubble-server-cert-validity-duration=94608000s"
                - "--hubble-relay-client-cert-generate"
                - "--hubble-relay-client-cert-validity-duration=94608000s"
          hostNetwork: true
          serviceAccount: "hubble-generate-certs"
          serviceAccountName: "hubble-generate-certs"
          restartPolicy: OnFailure
      ttlSecondsAfterFinished: 1800
