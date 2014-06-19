#! /bin/sh
# Prepare answers to questions about IPCC authors, in TSV format
#
# USAGE:
# answer.sh [user] [host] [password]
# with
#   user - optional, string, database user name, defaults to 'root'
#   host - optional, string, database host name, defaults to 'localhost'
#   password - optional, string, database user password,
#              defaults to 'no password' which provides no password;
#              an empty string results in a prompt for password.
user=${1:-'root'}
host=${2:-'localhost'}
password=${3:-'no password'}

if [ "$password" = 'no password' ]
then
  passwordParam=''
else
  passwordParam="--password $password"
fi

query="mysql --host $host --user $user $passwordParam"

# change to the script's directory
cd $(dirname $0)

answer()
{
  mkdir -p "answer$1"
  $query \
    < "question$1/$2.sql" \
    > "answer$1/$2.tsv"
}

echo 'Who are the authors that have participated'
echo 'in more than 1, 2, 3, or 4 assessment reports?'
answer 01 list-names
answer 01 count-multiple-participations

echo 'Who are the authors that have participated'
echo 'in more than 1, 2, 3, or 4 assessment reports'
echo 'while holding at least 1 of the 3 elected roles in the IPCC'
echo 'in each assessment report of participation'
echo '(Coordinating Lead Author, Lead Author, Review Editor)?'
answer 02 count-multiple-resp-participations

ls -l -h answer*
echo 'Export Complete'
