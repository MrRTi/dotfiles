set -gx KUBECONFIG ~/.kube/config
set -l kube_configs (path filter -f -- ~/.kube/*-config ~/.kube/config 2>/dev/null)
if test (count $kube_configs) -gt 0
    set -gx KUBECONFIG (string join ':' $kube_configs)
end
