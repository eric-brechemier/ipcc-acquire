# IPCC Acquire
Query `ipcc` database from MySQL server and return data in TSV format
(Tab-Separated Values).

## Languages

* SQL
* Shell

## Prerequisites

The `ipcc` database can be imported from CSV files to MySQL server
with scripts and data included in the ipcc-database repository:  
https://github.com/medea-project/ipcc-database

## Run

Using defaults, the script runs locally as database user 'root'
without password:

    $ acquire.sh

Extra parameters can be provided to connect to a remote database,
specifying the user name and hostname:

    $ acquire.sh 'user' 'hostname'

## Attribution

[MEDEA Project][MEDEA]
[CC-BY][] [Arts Déco][Arts Deco] & [Sciences Po][Medialab]

[MEDEA]: http://www.projetmedea.fr/
[CC-BY]: https://creativecommons.org/licenses/by/4.0/
         "Creative Commons Attribution 4.0 International"
[Arts Deco]: http://www.ensad.fr/en
             "École Nationale Supérieure des Arts Décoratifs"
[Medialab]: http://www.medialab.sciences-po.fr/
               "Sciences Po Médialab"
