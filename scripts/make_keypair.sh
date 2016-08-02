#! /bin/bash



cd `dirname $0`
. config.vars


if [ -f $TF_VAR_KEYFILE ] ; then

    echo "ssh key file exist:"
    ls -l $TF_VAR_keyfile*

else 
    ssh-keygen -t rsa -b 2048 -C "generated-keypair-for-jupyter-hub" -f $TF_VAR_keyfile -q -P ""
fi
