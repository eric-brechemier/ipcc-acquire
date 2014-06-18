# IPCC Acquire
Query 'giec' database from MySQL server and return data in TSV format
(Tab-Separated Values).

## Languages

* SQL
* Shell

## Prerequisites

You can request a copy of the 'giec' database from Sciences Po
by sending an email with a description of your intended use case
to <medialab@sciencespo.fr>.

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
