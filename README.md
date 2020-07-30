![Terraform test](https://github.com/getamis/terraform-kubernetes-ignition/workflows/Terraform%20test/badge.svg) [![GitHub license](https://img.shields.io/github/license/getamis/terraform-kubernetes-ignition)](https://github.com/getamis/terraform-kubernetes-ignition/blob/master/LICENSE)
# Terraform Kubernetes Ignition module
A terraform Ignition modules to bootstrap a Kubernetes cluster with CoreOS Container Linux/Flatcar Container Linux/Fedora CoreOS. (Experiment)

This repo also contains the following submodules:

* kubelet: Bootstrap a worker node to join a Kubernetes cluster.
* kubeconfig: Generate a kubeconfig from variabels.
* extra-addons.
  - [x] Addon manager.
  - [x] Metrics server.

## Requirements

* Terraform v0.12.0+.
* [terraform-provider-ignition](https://github.com/terraform-providers/terraform-provider-ignition) 1.2.1+.

## Usage example
The following block is show you how to use this module for bootstrapping a cluster:
 
 ```hcl
resource "random_id" "bootstrap_token_id" {
  byte_length = 3
}

resource "random_id" "bootstrap_token_secret" {
  byte_length = 8
}

resource "random_password" "encryption_secret" {
  length  = 32
  special = true
}

module "ignition_kubernetes" {
  source = "git::ssh://git@github.com/getamis/terraform-kubernetes-ignition"

  service_network_cidr = "10.96.0.0/12"
  pod_network_cidr     = "10.244.0.0/16"
  network_plugin       = "flannel"
  internal_endpoint    = "https://127.0.0.1:6443"
  etcd_endpoints       = "https://127.0.0.1:2379"
  encryption_secret    = random_password.encryption_secret.result

  tls_bootstrap_token = {
    id     = random_id.bootstrap_token_id.hex
    secret = random_id.bootstrap_token_secret.hex
  }

  // Create certs through https://registry.terraform.io/providers/hashicorp/tls/latest/docs.
  certs = {
    etcd_ca_cert = "1JR6RQsGgj5MkYrsvnA87CmB9/GgKLje7TVuV4WnpfI="

    ca_cert                       = "0UJHPe+UtjQAed6LhHLGcX1+QrISIX/5Bt/zRcCETwg="
    ca_key                        = "EcVHdpIwHltNSwRAl0jHfN0wC9gNFGgYoJ9KZvokYEc="
    admin_cert                    = "6QtninR/MVATtac7wfUKu4gpHydi3zRQzIcIHU9ozjw="
    admin_key                     = "YpTT+PjcuC5CybVcl6QxilZ0R+J0sHrarXZbvMxkOBY="
    apiserver_cert                = "/iIrHSh4RCT7OZshAc08wGPDBG9LXPpBqXfsMxjICug="
    apiserver_key                 = "hxIRmFbWaDCcNX4DCxRL3K8tsSGp/GDGSNiD22F0vAM="
    apiserver_kubelet_client_cert = "btKP9rofBTAP13qt2J9bfQqyeDyXzgnt2cWR+97eGsE="
    apiserver_kubelet_client_key  = "nQGiyCE9BFxIH/vyETEYzNwY4kwnzAYGgtW8leYVxzg="
    apiserver_etcd_client_cert    = "u1CjxP3EsRRQoyYdMhujS6EJypnI/MzM+7k05HMxexo="
    apiserver_etcd_client_key     = "2iPUCEALAAcf33WNhyEWICjl9PHM7bQvTrfojyrDLEI="
    controller_manager_cert       = "GZbupgQT6We+nCiaBZOtOJsABuqfEwK3Kq3qopIZ1MY="
    controller_manager_key        = "N3DSa/IRNXm27yj2HBA8ioa2Kh6odzOCAWc/DSbX9Kw="
    scheduler_cert                = "R9K3FJuBw6S3TACQxcBcn6YO5sgN27TUEgvkYqEzNLg="
    scheduler_key                 = "4wItHrT6CKASLSaYDC89kZvEgUR0k+s91t97Nxud9XI="
    front_proxy_ca_cert           = "MablFnDw4eP6f9FHz95l/bzo4rUW6TRzHKZzFAUfguU="
    front_proxy_ca_key            = "dWwwluo9gkMjnHb0ZzKARU4AldP4w/jo73l0PV/iDro="
    front_proxy_client_cert       = "vgaw53vwIiaoajlUSl4XNcUVHXBOzygSciGzQB2SAjU="
    front_proxy_client_key        = "EWfrVxHeSaXzgD2PNQBCT8Ip4ece2bZTJZYJmJQf0pY="
    sa_pub                        = "x6PXLHszHxv7SsIUhcm4esK7bQEh4dlif1R+r3y71C0="
    sa_key                        = "8G3WG3nqDcUE8hKW3KbYbMh+zwjWxzy6VB2Z1I247c4="
  }
}
```

> See [docs/variables/master.md](docs/variables/master.md) for the detail variable inputs and outputs.

## Contributing
There are several ways to contribute to this project:

1. **Find bug**: create an issue in our Github issue tracker.
2. **Fix a bug**: check our issue tracker, leave comments and send a pull request to us to fix a bug.
3. **Make new feature**: leave your idea in the issue tracker and discuss with us then send a pull request!

## License
This project is licensed under the Apache 2.0 License - see the [LICENSE](LICENSE) file for details.
