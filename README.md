# sinatra_memo_app

## What is this?
This is the simple sinatra memo app.

## How to Use
1. Please git clone or download zip.
2. Move to the directory where you downloaded it.
3. Install `Bundler`.
```
$ gem install bundler
```
4. Use bundler to install gem in bulk.
```
$ bundle install
```
5. Configuring PostgreSQL.
First, install PostgreSQL on Linux. If you are using WSL2, refer to the following link.

[Add or connect a database with WSL | Microsoft Docs](https://docs.microsoft.com/en-us/windows/wsl/tutorials/wsl-database)

Next, execute the following command on the terminal.
```
$ sudo service postgresql start
$ sudo -u postgres psql
postgres=# create database memo_db;
postgres=# \c memo_db
memo_db=# create table memos (memo_id serial primary key, memo_title varchar(20), memo_content varchar(400));
```
6. Start app.rb with Bundler.
```
$ bundle exec ruby app.rb
```
7. Access `http://localhost:4567/memos` with your browser.

8. If an error occurs.
Grant SuperUser privileges to the role that is attempting to connect.

[ruby - Rails: PG::InsufficientPrivilege: ERROR: permission denied for relation schema_migrations - Stack Overflow](https://stackoverflow.com/questions/38271376/rails-pginsufficientprivilege-error-permission-denied-for-relation-schema-m)
