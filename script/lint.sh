#!/bin/bash
# Check for linting errors
find . -name '*Dockerfile*' | \
    while read NAME; do
        echo $NAME
        bash -c "docker run --rm -i hadolint/hadolint < $NAME" \;
        [[ $? = 0 ]] && RESULT="OK" || RESULT="FAIL"
        echo $RESULT
    done
    