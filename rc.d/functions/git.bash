
add-upstream() {
if [ -z "$1" ]; then
    echo "Must supply a git repository address as argument!"
fi
  git remote add upstream $1
  echo "Original upstream $1 added"
}

sync-to-upstream() {
  git fetch upstream
  git checkout master
  git merge upstream/master
  git push

if [ .gitmodules ]; then
	echo "Updating submodules" 
	git submodule update --init
fi
}

reset-to-upstream() {
  git fetch upstream
  git checkout master
  git reset --hard upstream/master
  git push origin master --force
}

fetch-one-branch() {
if [ $# != 1  ]; then
  echo "usage: $0 {repository url} {branch name} (opt: out dir}"
  exit;
fi
  git clone -b $2 --single-branch $1
}


fetch-all-branches() {
  for b in `git branch -r | grep -v -- '->'`; do git branch --track ${b##origin/} $b; done
  git fetch --all
  git pull --all
}

update-to-all-branches() {
if [ $# != 1  ]; then
  echo "usage: $0 <filname>"
  exit;
fi

branches=`git for-each-ref --format='%(refname:short)' refs/heads/\*`
curr_branch=`git rev-parse --abbrev-ref HEAD`
# echo "curr_branch:"$curr_branch

filename=$1
file_in_repo=`git ls-files ${filename}`

if [ ! "$file_in_repo" ]; then
    echo "file not added in current branch"
    exit
fi

for branch in ${branches[@]}; do
    if [[ ${branch} != ${curr_branch} ]]; then
        git checkout "${branch}"
        git checkout "${curr_branch}" -- "$filename"
        git commit -am "Added $filename in $branch from $curr_branch"
        echo ""
    fi
done
git checkout "${curr_branch}"
}
