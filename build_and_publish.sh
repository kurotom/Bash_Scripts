#!/bin/bash

run_tests () {
  . run_tests.sh
  if (( $? != 0 )); then
    exit 10
  fi
}


update_pyproject_version () {

  while true; do
    read -p "Enter Version: " NEW_VERSION

    check=$(echo $NEW_VERSION | grep -e "[0-9]\.[0-9]\.[0-9]")
    size=$(echo $check | wc -c)

    if (( $size == 6 )); then
      # echo $NEW_VERSION
      break
    fi

  done

  if [[ $VERSION = $NEW_VERSION ]]; then
    echo "Keeping previous version - $VERSION."

  else
    sed -i "s/version = \"0.1.2\"/version = \"$NEW_VERSION\"/" $PYPROJECT
    if (( $? == 0 )); then
      echo "Version has changed to $NEW_VERSION".
    else
      exit 21
    fi
  fi
}


to_github () {
  changes=$(git status --porcelain | wc -l)
  if (( $changes > 0 )); then
    while true; do
      read -p 'Enter commit: ' COMMIT
      lenght=$(echo $COMMIT | wc -c)
      # minimum lengh text == 'v0.0.0'
      if (( $lenght > 6 )); then

        git add .
        git commit -m "$COMMIT - $NEW_VERSION"
        git push

        if (( $? == 0 )); then
          echo "Changes has been pushed.".
        else
          exit 32
        fi

        break
      fi

    done
  else
    echo "No changes in the repository."
    exit 33
  fi
}

petry_publish () {
  poetry --build publish
  if (( $? == 0 )); then
    echo "Package publish on Pypi.".
  else
    exit 41
  fi
}



PYPROJECT='pyproject.toml'


PREV_VERSION=$(cat $PYPROJECT | grep "version =")
VERSION=$(echo $PREV_VERSION | cut -d " " -f 3 | xargs)


run_tests
if (( $? == 0 )); then
  echo -e '\n\n-----------------------------------------------------------\n'
  echo -e "Previous version of the project: $VERSION\n"

  update_pyproject_version

  to_github

  petry_publish
fi
