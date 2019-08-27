## Setup:

bundle

### To set up the database

Connect to `psql` and create the `pairer` database:

```
CREATE DATABASE pairer;
```

To set up the appropriate tables, connect to the database in `psql` and run the SQL scripts in the `db/migrations` folder in the given order.

### To run the Pairer program:

```
ruby run_pairer.rb
```
