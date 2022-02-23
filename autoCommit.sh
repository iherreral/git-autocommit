#!/bin/bash


# Absolute path to this script, e.g. /home/user/bin/foo.sh
SCRIPT=$(readlink -f "$0")
# Absolute path this script is in, thus /home/user/bin
SCRIPTPATH=$(dirname "$SCRIPT")
# Log File. Cleaned at each iteration
LOGFILE=commit_log
# Change this to your paths
path_repo="$SCRIPTPATH/repo/"


cd $SCRIPTPATH

message="*Auto-commit*"

# git status --short
# D File1
# M File2
# ?? File3


echo $(date)>"$SCRIPTPATH/$LOGFILE"
cd $path_repo
echo "Estado actual">>"$SCRIPTPATH/$LOGFILE"
git status --short >>"$SCRIPTPATH/$LOGFILE"

# Check what action to take on each file depending on whether it has been deleted, modified or added.
git status --short |  while read -r stat; do
  if [[ "$stat" =~ ^"D"+.*+$ ]];then #Deleted file
    git add "$(echo $stat | awk '{print $2}')">>"$SCRIPTPATH/$LOGFILE"
  elif [[ "$stat" =~ ^"M"+.*+$ ]];then #Modified file
    git add "$(echo $stat | awk '{print $2}')">>"$SCRIPTPATH/$LOGFILE"
  elif [[ "$stat" =~ ^"??"+.*+$ ]];then #Added file
    git add "$(echo $stat | awk '{print $2}')">>"$SCRIPTPATH/$LOGFILE"
  else
    echo "OTHER">>"$SCRIPTPATH/$LOGFILE"
  fi
done
#Commit local
git commit -m "$message">>"$SCRIPTPATH/$LOGFILE"

#Send changes to remote repo
git push>>"$SCRIPTPATH/$LOGFILE"
