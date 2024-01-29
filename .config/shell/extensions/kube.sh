#! /bin/sh

# NOTE: find pods
kubefp() {
  KUBE_NAMESPACE=$(kubefn)
  kubectl get pods --field-selector=status.phase=Running -n "${KUBE_NAMESPACE:-default}" | fzf | awk '{print $1}'
}

alias kubelogs='kubefp | xargs kubectl logs'
alias kubebash='kubeexec /bin/bash'

# NOTE: find namespace
kubefn() {
  kubectl get namespace | fzf | awk '{print $1}'
}

alias kubeexec='kubefp | xargs -o -I@ kubectl exec -ti @ -c netology-rails -n ${KUBE_NAMESPACE:-default} -- '

