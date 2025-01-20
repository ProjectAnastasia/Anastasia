# README.md
This `SQL` directory contains the database commands (`.sql` files) needed
to create and/or update your own Anastasia game database.

## Helpful Advice
Here's some helpful advice that should be said right up front:

    !!-- BEFORE YOU DO ANYTHING TO YOUR DATABASE --!!

    1. Create a full backup of your database!
    2. Make sure you can restore the backup on a spare machine!

If you can do these two things, you'll probably be able to fix anything you
accidentally break.

If you can't do these two things, stop here. Consult your favorite search
engine and/or large language model AI about 'MariaDB Administration'. Come
back after you've learned and practiced how to do the above two things.

Now that you are warned... we continue.

## Schema Files
The filenames are numbered sequentially:

    000_anatasia_schema.sql
    001_anatasia_data.sql

These files should be applied in numerical order, starting with 000 and
going up. Going out of order may lead to errors and an unusable database.

## Database Upgrade
If you have an existing database, you can find out where you are in the
sequence with the query:

    select sql_version from db_metadata;

If this query returns `2` (for example), you should run 003, 004, etc.
in numerical order to upgrade your existing database.

## Linux + Docker
If you are on Linux, and you have Docker installed, the script
`bin/init-game-db` will automatically run the scripts in numerical order
when the container is initialized. This will give you a working game
database container, all ready to go, in a single command.

## Warning
Script `001_anatasia_data.sql` adds rows to table `admin` with the BYOND
names of the original creators of Anastasia. If you don't want these two
fine gentlemen to have +ALL permissions on your server, just delete those
lines from your `001_anatasia_data.sql` before you run it on your database.

ProTip: Substitute your own BYOND name to give yourself +ALL permissions
on your own server!
