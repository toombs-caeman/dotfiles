silent which kubectl || return 0

. <(kubectl completion bash)

silent which eksctl && . <(eksctl completion bash)
silent which helm && . <(helm completion bash)

k8s_prompt()
{ 
    CONTEXT=$(kubectl config current-context 2> /dev/null);
    if [ $? -eq 0 ]; then
        echo "$(namespace)@$(kubectl config current-context)";
    else
        echo "";
    fi
}
namespace () 
{ 
    ctx="$(kubectl config current-context 2> /dev/null)";
    if [ ! $? -eq 0 ]; then
        echo "";
    else
        kubectl config view 2> /dev/null | grep --colour=auto -A4 " context:" | egrep --colour=auto -A4 "cluster: ${ctx}$" | grep --colour=auto namespace | tr -s ' ' | cut -d ' ' -f 3;
    fi
}
