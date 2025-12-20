function kube_shell
  if test (count $argv) -ge 1
      set kube_ns $argv[1]
  else
      set kube_ns (kubectl get ns | tail -n +2 | fzf | awk '{print $1}')
  end

  if test -z "$kube_ns"
    echo "Namespace required"
    return 1
  end

  set kube_pod (kubectl get pods -n $kube_ns | tail -n +2 | fzf | awk '{print $1}')

  if test -z "$kube_pod"
    echo "Pod required"
    return 1
  end

  kubectl exec -it $kube_pod -n $kube_ns -- sh -c '
    if [ -x /bin/bash ]; then
        exec /bin/bash
    fi
  '
end
