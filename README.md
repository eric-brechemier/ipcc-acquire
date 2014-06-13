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
