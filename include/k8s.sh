
# source completions
silent which kubectl && . <(kubectl completion bash)
silent which eksctl && . <(eksctl completion bash)
silent which helm && . <(helm completion bash)

k8s_prompt()
{ 
    ctx="$(kubectl config current-context 2> /dev/null)" || return
    echo $ctx
    kubectl config view 2> /dev/null | grep --colour=auto -A4 " context:" \
        | egrep --colour=auto -A4 "cluster: ${ctx}$" \
        | grep --colour=auto namespace | tr -s ' ' | cut -d ' ' -f 3;
}
