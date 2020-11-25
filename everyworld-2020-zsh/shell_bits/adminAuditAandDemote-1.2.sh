#!/bin/bash
#
# this script will roll over user accounts, and demote any user accounts that
# are admins
#
exclude_user_array=(
  "root"
  "_uucp"
)

users_array=( $(dscl . list /Users) )

checkUser()
{
  user_to_check=${1}
  #echo "${user_to_check} .."
  user_shell=$(dscl . read /Users/${user_to_check} UserShell)
  if [ "${user_shell}" != "/usr/bin/false" ] ; then
    admin_check=$(dseditgroup -o checkmember -m "${user_to_check}" admin | grep "is a member of admin")
    if [ -n "${admin_check}" ] ; then
      demoteUser ${user_to_check}
    fi
  fi
}

demoteUser()
{
  user_to_demote="${1}"
  echo "demoting ${user_to_demote} .."
  dseditgroup -o edit -d ${user_to_demote} -t user admin
}

#
# main loop
#

for user_to_process in "${users_array[@]}" ; do
  skip_user=false
  for exclude_user in "${exclude_user_array[@]}" ; do
    if [ "${user_to_process}" == "${exclude_user}" ] ; then
      echo "skipping ${user_to_process}.."
      skip_user=true
      break
    fi
  done
  if ! ${skip_user} ; then
    checkUser ${user_to_process}
  fi
done

exit
