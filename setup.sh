#!/bin/bash

# Usage:
# ./setup.sh ~/Workspace/mci-test/test git@bitbucket.org:jandjerry/ci-test.git
# ./setup.sh <workspace> <end-git-repo>
#
rm $1 -Rf

#Prepare variables

SETUP_DIR=`pwd`

if [ -z "$1" ]; then
	echo "
	You need to specify workspace dir
	eg: ./setup.sh /var/www/my-workspace
	"
	exit 0
fi

if [ -d $1 ]; then
	echo "
	Workspace dir exists!
	"
	exit 0
fi

if [ -z $2 ]; then
    echo "You need provide git repo (github|bitbucket...)"
    exit 0
fi


WORKSPACE_DIR=$1
GIT_END_REPO=$2

MAIN_DIR=$(readlink -m "$WORKSPACE_DIR/main")
MAIN_REPO_DIR=$(readlink -m "$MAIN_DIR/repo.git") #We dont need worktree for this repo

BUILD_DIR=$(readlink -m "$WORKSPACE_DIR/build")
BUILD_REPO_DIR=$(readlink -m "$BUILD_DIR/repo.git")
BUILD_WORK_TREE_DIR=$(readlink -m "$BUILD_DIR/worktree")

CI_DATA_DIR='/tmp/mci-build'
CI_BUILD_STATUS_DIR="$CI_DATA_DIR/build-status"
CI_DEPLOY_STATUS_DIR="$CI_DATA_DIR/deploy-status"

#Reset all #TODO only for testing
rm $WORKSPACE_DIR -Rf
rm $CI_DATA_DIR -Rf


#Setup ci data dir
mkdir -p $CI_BUILD_STATUS_DIR
mkdir -p $CI_DEPLOY_STATUS_DIR

### Setup main repo
mkdir -p $MAIN_REPO_DIR
cd $MAIN_REPO_DIR
git init --bare

cp $SETUP_DIR/hooks/pre-receive $MAIN_REPO_DIR/hooks
chmod +x $MAIN_REPO_DIR/hooks/pre-receive

cp $SETUP_DIR/hooks/post-receive $MAIN_REPO_DIR/hooks
chmod +x $MAIN_REPO_DIR/hooks/post-receive
#Append end repo, use coma instead of slash will avoid conflict with url
sed -i s,__GIT_END_REPO__,$GIT_END_REPO,g $MAIN_REPO_DIR/hooks/post-receive


### Setup build repo
mkdir -p $BUILD_REPO_DIR
mkdir -p $BUILD_WORK_TREE_DIR


#Setup build script
cp $SETUP_DIR/build.sh $BUILD_DIR
chmod +x  $BUILD_DIR/build.sh

#Setup deploy scripts
cp $SETUP_DIR/deploy.sh $BUILD_DIR
chmod +x  $BUILD_DIR/deploy.sh


cd $BUILD_REPO_DIR
git init --bare
GIT_WORK_TREE=$BUILD_WORK_TREE_DIR git commit --allow-empty -m "Initial commit" #TODO do we need this ?

echo -e "#!/bin/sh\nGIT_WORK_TREE=$BUILD_WORK_TREE_DIR git checkout -f\n" > $BUILD_REPO_DIR/hooks/post-receive

#DONE
echo "
	DONE!
	Your repository: ssh://git@ci.yourdomain.com${MAIN_REPO_DIR}
"
