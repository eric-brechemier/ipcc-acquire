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

echo '*******************************************************'
echo 'Q1.'
echo 'Who are the authors that have participated'
echo 'in more than 1, 2, 3, or 4 assessment reports?'
echo '*******************************************************'
echo 'Answers:'
answer 01 list-names
answer 01 count-cumulated-participations
answer 01 count-cumulated-participations-by-wmo-country-group
answer 01 count-cumulated-participations-by-eco-country-group
answer 01 count-cumulated-participations-by-cli-country-group
answer 01 count-total-participations-by-institution
answer 01 count-cumulated-participations-by-institution-type
answer 01 count-cumulated-participations-by-working-group
answer 01 count-total-participations-by-country
ls -l -h -o answer01

echo '*******************************************************'
echo 'Q2.'
echo 'Who are the authors that have participated'
echo 'in more than 1, 2, 3, or 4 assessment reports'
echo 'while holding at least 1 of the 3 elected roles in the IPCC'
echo 'in each assessment report of participation'
echo '(Coordinating Lead Author, Lead Author, Review Editor)?'
echo '*******************************************************'
echo 'Answers:'
answer 02 list-resp-names
answer 02 count-cumulated-resp-participations
answer 02 count-cumulated-resp-participations-by-wmo-country-group
answer 02 count-cumulated-resp-participations-by-eco-country-group
answer 02 count-cumulated-resp-participations-by-cli-country-group
answer 02 count-total-resp-participations-by-institution
answer 02 count-cumulated-resp-participations-by-institution-type
answer 02 count-cumulated-resp-participations-by-working-group
answer 02 count-total-resp-participations-by-country
ls -l -h -o answer02

echo '*******************************************************'
echo 'Q3.'
echo 'Who are the authors that have participated in'
echo 'more than one working group (what we call bridge authors)?'
echo '*******************************************************'
echo 'Answers:'
answer 03 list-bridge-author-names
ls -l -h -o answer03

echo '*******************************************************'
echo 'Export Complete'
echo '*******************************************************'
