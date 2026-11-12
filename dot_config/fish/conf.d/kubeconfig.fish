# NOTE: kubeconfigs live in $XDG_CONFIG_HOME/kube, not ~/.kube. OrbStack still
# writes its context to ~/.kube/config when its k8s is enabled; copy it over if
# you turn that on.
set -l kube_dir $XDG_CONFIG_HOME/kube
set -gx KUBECONFIG $kube_dir/config
set -l kube_configs (path filter -f -- $kube_dir/*-config $kube_dir/config 2>/dev/null)
if test (count $kube_configs) -gt 0
    set -gx KUBECONFIG (string join ':' $kube_configs)
end
