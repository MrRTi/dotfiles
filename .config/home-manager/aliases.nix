{
  g = "git";
  "..." = "cd ../..";

# navigation
  cd..="cd ..";
  ..="cd ..";
  ....="cd ../../";
  ~~="cd ~/";

# shell
  md="mkdir";
  sl="ls";
  ll="lsd -la || ls -la";
  batp="bat --style=plain --paging=never";
  batn="bat --paging=never";
  zshr="source ~/.zshrc";

# tmux
  tmuxn="tmux new -As ${PWD##*/}"

# docker-compose
  d="docker";
  dc="d compose";
  dcr="dc run --rm --use-aliases";
  dcrs="dcr --service-ports";

# podman
  p="podman";
  pc="podman compose";
  pcr="pc --rm --use-aliases";
  pcrs="pcr --service-ports";

# git
  g="git";
  gs="g status ";
  gc="g commit";
  gcv="gc -v";
  gcm="gc -m";
  gca="gc --ammend";
  gcane="gc --amend --no-edit";
  guc="g reset HEAD~";
  gfrs="g flow release start";
  gfrf="g flow release finish";
  ga="g add";
  gco="g checkout";
  gb="g branch";
  gbmv="g branch -M";
  gbrm="g branch -D";
  grup="g remote update";
  gup="g pull";
  gupr="g pull -r";
  gp="g push";
  gpt="gp && gp --tags";
  gpuo="gp -u origin";
  gpfo="gp -f origin";
  glol="g log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'";

# terraform
  t="terraform";
  ti="t init";
  tp="t plan";
  ta="t apply";

# complex aliases
  tldrf="tldr --list | fzf --preview \"tldr {1} --color=always\" --preview-window=right,70% | xargs tldr";
  gcof="git branch --sort=-committerdate | fzf --header \"Checkout Recent Branch\" --preview \"git diff --color=always {1}\"  | xargs git checkout";
  gcofd="git branch --sort=-committerdate | fzf --header \"Checkout Recent Branch\" --preview \"git diff --color=always {1} | delta\" --pointer=\"\" | xargs git checkout";

# Kubernetes
  kubefp="export KUBE_NAMESPACE=$(kubefn) && kubectl get pods --field-selector=status.phase=Running -n ${KUBE_NAMESPACE:-default} | fzf | awk '{print $1}'";
  kubelogs="kubefp | xargs kubectl logs";
  kubebash="kubeexec /bin/bash";
  kubefn="kubectl get namespace | fzf | awk '{print $1}'";
  kubeexec="kubefp | xargs -o -I@ kubectl exec -ti @ -c netology-rails -n ${KUBE_NAMESPACE:-default} -- ";

# yandex cloud
  ycls="yc compute instance list --format json | jq --raw-output '.[] | \"\(.name) \(.status)\"'";
  ycfn="ycls | fzf | awk '{print $1}'";
  ycup="ycfn | xargs yc compute instance start --name";
  ycstop="ycfn | xargs yc compute instance stop --name";
}
