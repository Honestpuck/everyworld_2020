WEEKS=$1
DAYS=$(($WEEKS * 7))
date -v +${DAYS}d
