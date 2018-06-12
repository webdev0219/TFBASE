Ticketfinders
=============

Getting Started
---------------

Make sure you have Ruby version 2.0.0 installed.
Recommend to use [RVM](https://rvm.io/).

You will need [ImageMagick](https://www.imagemagick.org/) installed.

The application uses PostgreSQL. Versions 8.2 and up are supported.
Create database and config file `config/database.yml` for connection.
File example:

    default: &default
      adapter: postgresql
      encoding: unicode
      pool: 5
      host: <localhost>
      username: <username>
      password: <password>

    development:
      <<: *default
      database: tfbase_development

    production:
      <<: *default
      database: tfbase_production

Also you need to create `config/application.yml` file to set env. variables.
There is an example:

    ## Access to the admin section
    ADMIN_NAME: "admin"
    ADMIN_PASSWORD: "password"

    ## Mailer settings
    MAIL_FROM: "info@ticket-finders.com"
    DEVELOPER_EMAIL: "<your email for test on development and staging>"

    ## Paypal payment button params
    PAYPAL_BUSINESS_EMAIL: "<email of business sandbox account>"
    PAYPAL_SANDBOX_MODE: "<1 or 0 but warning: 0 is production version>"

When done, run:

    $ bin/bundle install --without production
    $ bin/rake db:create db:migrate

Install demo data using command `bin/rake db:seed` if you need.

Application ready for start. You can launch webserver with
command `bin/rails server` and see home page
at [localhost:3000](http://localhost:3000/) url.


Deploy
------

### Before start

Add correct deploy variables to your local `config/application.yml` file:

    ## Deploy variables
    #  for production
    PRODUCTION_DEPLOY_DOMAIN: "<production server name or ip-address>"
    PRODUCTION_DEPLOY_TO: "<path to an application directory on the server>"
    PRODUCTION_DEPLOY_USER: "<name of user on the server>"
    PRODUCTION_DEPLOY_BRANCH: "<name of branch in the project's repository>"
    #  and for staging:
    STAGING_DEPLOY_DOMAIN: "<staging server name or ip-address>"
    STAGING_DEPLOY_TO: "<path to an application directory on the server>"
    STAGING_DEPLOY_USER: "<name of user on the server>"
    STAGING_DEPLOY_BRANCH: "<name of branch in the project's repository>"


### The first deploy on the server

If this is the first deploy to server at all (not only yours) you need to
prepare server:

* run `mina setup` or `mina production setup` for production

* create files 'database.yml' and 'application.yml' with correct credentials
  in 'shared/config' directory on the server. Use format described
  in "Getting Started" section of this readme, but add to 'application.yml'
  next variables:

        SECRET_KEY_BASE: "<secret string generated by bin/rake secret>"

        ## Mailer settings
        SENDGRID_API_KEY: "<this is secret>"

### Run deploy

Run deploy with command `mina deploy` (or `mina production deploy`).

Unfortunately for a production server you need to do some manual work to finish
deploy. You need to run this command as root user:

    service unicorn restart


Previous notes (please do not use now)
--------------------------------------

### A few things to check before deploying to remote machine

> Login to server from terminal

`ssh root@ip`

> Copy & Replace **/config/database.yml** & **/config/application/yml** with pre-completed file from **/home/rails** or just copy working files from old version of app.

<!-- -->
> Bundle install inside the new folder

`bundle`

> Bundle update

`bundle update`

> Precompile assets

*DB dump and create is Deprecated*

> Sometimes it's necessary to drop & reseed the database, here's how to do it

> Change user to rails (database administrator)

`su - rails`

> Start PostgreSQL with `psql`

<!-- -->
> Check for current users accessing the database

`SELECT * FROM pg_stat_activity;`

> Take note of **pid** number from results, then kill as needed

`SELECT pg_terminate_backend(pid_int);`

> Switch user back into root

`su - root`

> Navigate to app folder and drop database

`RAILS_ENV=production rake db:drop`

> Then run the following commands (in order) to create, migrate & seed the database

`RAILS_ENV=production rake db:create`
`RAILS_ENV=production rake db:migrate`
`RAILS_ENV=production rake db:seed`

> Precompile assets with this command

`RAILS_ENV=production rake assets:precompile`

> Ensure root app folder is owned by rails user

`chown -R rails: /home/rails/ticketfinders1/`

<!-- -->
> Give read-write permissions to **tmp/cache**

`chmod -R 0777 cache/`

<!-- -->
> **Troubleshoot** in root/log/production.log

`tail -f /home/rails/ticketfinders1/log/production.log`

> Further helpful resources

<!-- -->
> Restart Unicorn & Reload NGINX

<!-- -->
>[Ruby on Rails Digital Ocean deployment](https://www.digitalocean.com/community/tutorials/how-to-use-the-ruby-on-rails-one-click-application-on-digitalocean "Title")
