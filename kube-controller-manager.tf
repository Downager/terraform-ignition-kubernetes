data "ignition_file" "kube_controller_manager" {
  mode      = 420
  path      = "${local.etc_path}/manifests/kube-controller-manager.yaml"
  overwrite = true

  content {
    content = templatefile("${path.module}/templates/manifests/kube-controller-manager.yaml.tpl", {
      image          = "${local.containers["kube_controller_manager"].repo}:${local.containers["kube_controller_manager"].tag}"
      kubeconfig     = "${local.etc_path}/controller-manager.conf"
      pki_path       = "${local.etc_path}/pki"
      cluster_cidr   = var.network_plugin == "cilium-vxlan" ? "" : var.pod_network_cidr
      service_cidr   = var.service_network_cidr
      cloud_provider = local.cloud_provider
      extra_flags    = local.controller_manager_flags
      resources      = local.components_resource["kube_controller_manager"]
    })
    mime = "text/yaml"
  }
}

