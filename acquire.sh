#! /bin/sh
# Acquire records from 'giec' database for export in TSV format
#
# USAGE:
# acquire.sh [user] [host] [password]
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

database=ipcc
query="mysql --host $host --user $user $passwordParam"

# change to the script's directory
cd $(dirname $0)

# create output directory
mkdir -p output

acquire()
{
  $query $database \
    < "sql/acquire-$1.sql" \
    > "output/$1.tsv"
}

echo 'Acquire Author Records'
acquire authors

echo 'Acquire Contribution Type Categories'
acquire contribution-type-categories

echo 'Acquire Total Contributions List'
acquire total-contributions-list

echo 'Acquire Total Contributions Categories'
acquire total-contributions-categories

echo 'Acquire Role List'
acquire role-list

echo 'Acquire Role Categories'
acquire role-categories

echo 'Acquire Working Group List'
acquire working-group-list

echo 'Acquire Working Group Categories'
acquire working-group-categories

echo 'Acquire Assessment Reports List'
acquire assessment-report-list

echo 'Acquire Assessment Report Categories'
acquire assessment-report-categories

echo 'Acquire Years of Assessment Reports'
acquire assessment-report-years

echo 'Acquire Institution List'
acquire institution-list

echo 'Acquire Institution Categories'
acquire institution-categories

echo 'Acquire Institution Type List'
acquire institution-type-list

echo 'Acquire Institution Type Categories'
acquire institution-type-categories

echo 'Acquire Country List'
acquire country-list

echo 'Acquire Country Categories'
acquire country-categories

echo 'Acquire Country Group Categories'
acquire country-group-categories

echo 'Acquire Cumulated Working Group Categories'
acquire cumulated-working-group-categories

echo 'Acquire Cumulated Working Group in Assessment Report Categories'
acquire cumulated-working-group-in-assessment-report-categories

echo 'Acquire Cumulated Working Group in Country Group Categories'
acquire cumulated-working-group-in-country-group-categories

echo 'Acquire Cumulated Working Group in Institution Type Categories'
acquire cumulated-working-group-in-institution-type-categories

echo 'Acquire Cumulated Role in Assessment Report Categories'
acquire cumulated-role-in-assessment-report-categories

echo 'Acquire Cumulated Role in Country Group Categories'
acquire cumulated-role-in-country-group-categories

ls -l -h output
echo 'Export Complete'
