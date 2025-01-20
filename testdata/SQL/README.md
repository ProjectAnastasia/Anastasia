# README.md
This `testdata/SQL` directory contains `.sql` files applied to the database
during CI actions and other testing.

## Schema Files
The filenames of the regular `.sql` files are numbered sequentially:

    000_anatasia_schema.sql
    001_anatasia_data.sql

The filenames found in `testdata/SQL` are intended to 'squeeze between'
the production `.sql` files wherever they are needed. So for example:

    000a_test_data.sql

The order that this will be run against the database in testing is:

    000_anatasia_schema.sql
    000a_test_data.sql
    001_anatasia_data.sql

With clever naming, you can provide data to your tests wherever they
need it.
