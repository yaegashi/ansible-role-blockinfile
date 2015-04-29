#!/bin/bash

set -e

cd ${0%/*}

rm -rf testing
cp -R fixtures testing

run() {
        p="$1"
        base="${1%.yml}"
        testing_dir="$PWD/testing/$base"
        expected_dir="$PWD/expected/$base"
        idlog="$PWD/testing/$base-id.log"
        skipped="$testing_dir/SKIPPED"
        echo "$p: Running ansible-playbook"
        if ! ansible-playbook -v -i hosts -e testing_dir=$testing_dir $p; then
                echo -n "$p: "
                if test -e $skipped; then
                        cat $skipped
                        exit 2
                else
                        echo "ansible-playbook failed"
                        exit 1
                fi
        fi
        echo "$p: Running ansible-playbook again"
        ansible-playbook -v -i hosts -e testing_dir=$testing_dir $p | tee $idlog
        if ! grep -q 'changed=0.*failed=0' $idlog; then
                echo "$p: Idempotency missing"
                exit 1
        fi
        echo "$p: Checking results"
        if ! diff -x "*~" -ruN $expected_dir $testing_dir; then
                echo "$p: Unexpected changes detected"
                exit 1
        fi
}

code=0

tests=${@-*.yml}

for i in $tests; do
        echo
        echo "$i: Starting..."
        if ( run $i ); then
                echo "$i: Passed"
        elif test $? = 2; then
                echo "$i: Skipped"
        else
                echo "$i: Failed"
                code=1
        fi
done

exit $code
