REPO_PREFIX='CFS_Meta/http/cgi-bin/DVT_SRC'
MODULES='STRESS_NIS_USERCREATE STRESS_AD_USERCREATE ndmpcopy nfsvdm STRESS_AD_USERCREATE STRESS_CEPP STRESS_CLARIION_BACKEND STRESS_DMCAPACITY STRESS_FRDE STRESS_FRDE_LIMIT_MATURITY STRESS_JETSTRESS STRESS_NIS_USERCREATE STRESS_REPV2 STRESS_REPV2_INCR STRESS_SMB2WIN STRESSTOOLS'

for module in $(echo $MODULES); do
    echo "++:$module"
    dir="$module"
    repo="$REPO_PREFIX/$module"
    if [ -d ]; then
        echo "cvs update -d $dir"
        cvs update -d $dir
    else
        echo "cvs co -d $dir $repo"
        cvs co -d $dir $repo
done