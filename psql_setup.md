## Some initial settings for psql on Windows 10

1. First, verify the installation is complete (postgres is the default admin user).
```bash
psql -U postgres
```
2. You can use `\q` to exit, use `\l` to show all databases, use `\dt` to show all tables under the current database.
3. Create a user with the same username as your login name (your account name for Windows). Here, we need to execute this command with the default admin user `posrgres` (because we do not have any other user at this time). The name for the new user should be the same as your Windows login name (for my example, it's `john`). We should specify the `-P` parameter because we need the new user to have a password. We also use the `--interactive` option to make this process easier.
```bash
createuser -U postgres -P --interactive john
```
4. Now, we can user the new user created just now to log into the database system. However, PostgreSQL requires all users to have a database with the same name as their username. Since there is no database for `john` now, let's just use `postgres`.
```bash
psql -d postgres
```
5. Finally, create a database called `john`. Use `\l` to check the result.
```sql
CREATE DATABASE john;
```
6. From now on, you can simply use `psql` in a terminal to use PostgreSQL CLI.

## Troubleshooting

1. Postgres complains that `XXX command is not found`. Make sure you have added the correct directories into your `PATH`.
2. Postgres complains something else. Check your permission or see PostgreSQL documentation.