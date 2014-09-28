#!/bin/bash

DIR=$(cd $(dirname "$0"); pwd);

WORKSPACE_DIR="$DIR/.."
BUILD_DIR="$WORKSPACE_DIR/build"
BUILD_WORK_TREE_DIR="$BUILD_DIR/worktree"

cd $BUILD_WORK_TREE_DIR


BUILD_RESULT=""

if [ ! -f phpunit.phar ] ; then
	BUILD_RESULT="No phpunit.phar found"

else
	#Do PHPUnit Test
	php phpunit.phar -c app/ src/
	success=$?
	if [[ $success -eq 0 ]]; then
		#Let's see code coverage //TODO
		#Coverage parse result ?

		if [[ $success -eq 0 ]]; then
			BUILD_RESULT="1"
		fi
	else
		BUILD_RESULT="Test failed"
	fi

fi

if [ $1 ]; then
echo $BUILD_RESULT > $1
fi


if [[ "$BUILD_RESULT" == "1" ]]; then
    echo "NOTICE: Build successfully!"
	exit 0
fi
echo "ERROR: $BUILD_RESULT"
exit 1