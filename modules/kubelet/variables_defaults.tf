locals {
  binaries = merge({
    kubelet = {
      source   = "https://dl.k8s.io/${var.kubernetes_version}/kubernetes-node-linux-amd64.tar.gz"
      checksum = "sha512-2b4b60d0a27050f8b5835e830ad6318dab3b6dff81957c0b7485049ba3df89f4c58bc1f902f905f67957abee2ea1069ac115a204e74ff513a9ce7989f1fc7a52"
    }
    cni_plugin = {
      source   = "https://github.com/containernetworking/plugins/releases/download/v1.0.0/cni-plugins-linux-amd64-v1.0.0.tgz"
      checksum = "sha512-276633e8750e56fe864ba60fd3efef81c2157385219770a410cd7e423e88d68c024470b82420776d34027182227352f391a03cfd2e97ede9d0c7d8fa8fd578ec"
    }
  }, var.binaries)

  containers = merge({
    pause = {
      repo = "k8s.gcr.io/pause"
      tag  = "3.2"
    }
    cfssl = {
      repo = "quay.io/amis/cfssl"
      tag  = "v1.4.1"
    }
  }, var.containers)

  cloud_config = merge({
    // The provider for cloud services. Specify empty string for running with no cloud provider.
    provider = "aws"

    // The path to the cloud provider configuration file. Empty string for no configuration file.
    path = ""
  }, var.cloud_config)

  kubelet_config = merge({
    authentication = {
      anonymous = {
        enabled = false
      }

      webhook = {
        cacheTTL = "2m0s"
        enabled  = true
      }
    }

    authorization = {
      mode = "Webhook"
      webhook = {
        cacheAuthorizedTTL   = "5m0s"
        cacheUnauthorizedTTL = "30s"
      }
    }

    clusterDNS         = [cidrhost(var.service_network_cidr, 10)]
    clusterDomain      = "cluster.local"
    hairpinMode        = "hairpin-veth"
    cgroupDriver       = "systemd"
    kubeletCgroups     = "/systemd/system.slice"
    healthzBindAddress = "127.0.0.1"
    healthzPort        = 0
    readOnlyPort       = 0
    maxPods            = "$${MAX_PODS}"
  }, var.extra_config)
}
