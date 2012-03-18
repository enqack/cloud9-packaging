#!/bin/bash

CLOUD9_TAG=master
NODEBUILD_TAG=master
REBUILD_MODULES=/bin/true

# Usage: install_modules <architecture> <submodule name>
#             architecture: ia32 | x64
function install_modules {
    rm -rf "../../additional_modules/$1/$2"
    mkdir -p "../../additional_modules/$1/$2"
    cp -r "support/$2/node_modules" "../../additional_modules/$1/$2"
    rm -rf "support/$2/node_modules"
}

function rebuild_cloud9_modules {
    # remove support folder first to get no conflicts if source already existed
    perl -n -e '/\[submodule "(.*)"\]/ && print "$1\n"' < .gitmodules | xargs rm -rf

    # checkout submodules
    git submodule update --init --recursive

    # compile for 64bit
    pushd support/jsdav
    npm install
    popd

    install_modules x64 jsdav

    # compile for 32bit
    export CFLAGS="-m32"
    export CXXFLAGS="-m32"
    export LDFLAGS="-m32"

    pushd support/jsdav
    npm install
    popd

    install_modules ia32 jsdav
}

function checkout_cloud9 {
    # checkout cloud9 sources
    git clone https://github.com/ajaxorg/cloud9.git

    pushd cloud9
    git checkout -f $CLOUD9_TAG
    if $($REBUILD_MODULES); then
        rebuild_cloud9_modules
    fi
    popd
}

function checkout_node_builds {
    git clone https://github.com/lepokle/node-builds-v4.git

    pushd node-builds-v4
    git checkout -f $NODEBUILD_TAG
    popd
}

function package_cloud9 {
    rm -rf cloud9-package
    mkdir -p cloud9-package

    # copy to packaging including submodules
    cp -a tmp/cloud9/* cloud9-package

    rm cloud9-package/support/node-builds-v4/*
    cp -a tmp/node-builds-v4/* cloud9-package/support/node-builds-v4

    # remove git directories
    find cloud9-package -name \.git -delete
}

function apply_patches {
    # apply patches
    pushd cloud9-package
    
    echo "Patch middleware to avoid writing to program directory..."
    patch -p 1 < "../patches/middleware.js.patch"

    echo "Patch startup script"
    patch -p 1 < "../patches/cloud9.sh.patch"
    
    popd
}

mkdir -p tmp
pushd tmp
checkout_cloud9
checkout_node_builds
popd

package_cloud9
apply_patches

