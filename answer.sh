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
answer 01 list-cumulated-participations-by-institution
answer 01 count-cumulated-participations-by-institution
answer 01 count-cumulated-participations-percentage-by-institution
answer 01 count-cumulated-participations-by-institution-type
answer 01 count-cumulated-participations-by-working-group
answer 01 count-cumulated-participations-percentage-by-country
answer 01 count-cumulated-participations-by-country
answer 01 count-total-participations-by-wmo-country-group
answer 01 count-total-participations-by-eco-country-group
answer 01 count-total-participations-by-cli-country-group
answer 01 count-total-participations-by-institution
answer 01 count-total-participations-by-institution-type
answer 01 count-total-participations-by-working-group
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
answer 02 count-cumulated-resp-participations-by-institution
answer 02 count-cumulated-resp-participations-percentage-by-institution
answer 02 count-cumulated-resp-participations-by-institution-type
answer 02 count-cumulated-resp-participations-by-working-group
answer 02 count-cumulated-resp-participations-percentage-by-country
answer 02 count-cumulated-resp-participations-by-country
answer 02 count-total-resp-participations-by-wmo-country-group
answer 02 count-total-resp-participations-by-eco-country-group
answer 02 count-total-resp-participations-by-cli-country-group
answer 02 count-total-resp-participations-by-institution
answer 02 count-total-resp-participations-by-institution-type
answer 02 count-total-resp-participations-by-working-group
answer 02 count-total-resp-participations-by-country
ls -l -h -o answer02

echo '*******************************************************'
echo 'Q3.'
echo 'Who are the authors that have participated in'
echo 'more than one working group (what we call bridge authors)?'
echo '*******************************************************'
echo 'Answers:'
answer 03 list-bridge-author-names
answer 03 compute-working-group-membership-ratios
answer 03 list-bridge-authors-by-country
answer 03 list-bridge-authors-by-institution
answer 03 count-bridge-authors-by-wmo-country-group
answer 03 count-bridge-authors-by-eco-country-group
answer 03 count-bridge-authors-by-cli-country-group
ls -l -h -o answer03

echo '*******************************************************'
echo 'Q4.'
echo 'Are there particular chapters of the IPCC'
echo 'where these bridge authors tend to aggregate'
echo '(i.e. around particular themes)?'
echo '*******************************************************'
echo 'Answers:'
answer 04 list-bridge-chapters
answer 04 list-bridge-authors
answer 04 list-bridge-authors-by-chapter
answer 04 list-bridge-authors-by-chapter-type
ls -l -h -o answer04

echo '*******************************************************'
echo 'Q5.'
echo 'What kind of roles do the authors who participate'
echo 'in more than one working group occupy?'
echo '*******************************************************'
echo 'Answers:'
answer 05 count-bridge-authors-by-cumulated-wg-and-role
answer 05 count-bridge-authors-by-wg-and-role
ls -l -h -o answer05

echo '*******************************************************'
echo 'Q12.'
echo 'Where are French authors on the IPCC?'
echo 'To which chapters do they contribute the most?'
echo '*******************************************************'
echo 'Answers:'
answer 12 list-french-author-participations
answer 12 compute-participation-ratio-relative-to-other-countries-per-country-and-chapter
answer 12 compute-participation-ratio-relative-to-working-group-per-country-and-chapter
ls -l -h -o answer12

echo '*******************************************************'
echo 'Q13.'
echo 'Which countries have increased their participation in the IPCC'
echo 'and which have decreased their participation over time?'
echo '*******************************************************'
echo 'Answers:'
answer 13 count-authors-by-country-and-ar
answer 13 list-authors-and-roles-by-country-and-ar
ls -l -h -o answer13

echo '*******************************************************'
echo 'Q14.'
echo 'Which institutions have increased or decreased the most'
echo 'in participation over time?'
echo '*******************************************************'
echo 'Answers:'
answer 14 count-authors-by-institution-and-ar
answer 14 list-authors-and-roles-by-institution-and-ar
ls -l -h -o answer14

echo '*******************************************************'
echo 'Q15.'
echo '*******************************************************'
echo 'What are the differences in diversity (by country and by institution)'
echo 'between the working groups?'
echo '*******************************************************'
answer 15 count-participations-by-ar-author-role-institution-country
ls -l -h -o answer15

echo '*******************************************************'
echo 'Export Complete'
echo '*******************************************************'
