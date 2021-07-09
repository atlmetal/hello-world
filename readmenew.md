# Ayenda Backend
Ayenda backend is a project developed using Ruby on Rails and contains the code for Ayenda PMS (Property Management System) and AOS (Administrative Operative System).

## Table of contents

[Requirements](#Requirements)

[Getting Started](#Getting-Started)
1. [Installation on your machine (Linux and Mac)](#1-Installation-on-your-machine-Linux-and-Mac)
	* [Linux installation](#Linux-installation)
		* [Install system dependencies](#Install-system-dependencies)
		* [Install Node.js for Linux](#Install-Nodejs-for-Linux)
		* [Install Ruby dependencies for Linux](#Install-Ruby-dependencies-for-Linux)
		* [Install Database for Linux](#Install-Database-for-Linux)
		* [Redis installation and config for Linux](#Redis-installation-and-config-for-Linux)
	* [Mac installation](#Mac-installation)
		* [Install cmake](#Install-cmake)
		* [Install Node.js for Mac](#Install-Nodejs-for-Mac)
		* [Install Ruby dependencies for Mac](#Install-Ruby-dependencies-for-Mac)
		* [Install assets dependencies](#Install-assets-dependencies)
		* [Setup pre-commit gem](#Setup-pre-commit-gem)
		* [Install Database for Mac](#Install-Database-for-Mac)
			* [With brew](#With-brew)
			* [With PostgresApp](#With-PostgresApp)
			* [Docker alternative for Postgres](#Docker-alternative-for-Postgres)
		* [Redis installation and config for Mac](#Redis-installation-and-config-for-Mac)
			* [Docker alternative for Redis](#Docker-alternative-for-Redis)
	* [Final installation steps](#Final-installation-steps)
		* [Install Bundler and Rails](#Install-Bundler-and-Rails)
		* [Clone repository](#Clone-repository)
		* [Install app dependencies](#Install-app-dependencies)
		* [Setup config files](#Setup-config-files)
		* [Create DB and execute migrates, views and seeds](#Create-DB-and-execute-migrates-views-and-seeds-Not-required-if-you-have-a-db-backup)
		* [Run the webserver](#Run-the-webserver)

2. [Install docker and run all services as containers](#2-Install-docker-and-run-all-services-as-containers)
	*	[Docker Desktop application](#Docker-Desktop-application)
		*	[Linux](#Linux)
		*	[Mac and Windows](#Mac-and-Windows)
	* [Build docker images](#Build-docker-images)
	* [Setup config files for Docker](#Setup-config-files-for-Docker)
	* [Update database](#Update-database)
	* [Running and Stopping](#Running-and-Stopping)
	* [Attaching the console to a process for IO [or Debugging with Pry]](#Attaching-the-console-to-a-process-for-IO-or-Debugging-with-Pry)

[How to access to the web server](#How-to-access-to-the-web-server)
*	[Setup hosts](#Setup-hosts)
*	[Save Emails and Attachments](#Save-Emails-and-Attachments-chrome-complement-and-Gmail)

[Special Configurations](#Special-Configurations)
* [FYI B2 Chat](#FYI-B2-Chat)
* [FYI RateGain](#FYI-RateGain)
* [Electronic Billing](#Electronic-Billing)

[Wiki documentation](#Wiki-documentation)
* [Servers setup](#Servers-setup)
* [Automatic deployments](#Automatic-deployments)
* [Grafana and Prometheus](#Grafana-and-Prometheus)




## Requirements

* Ruby version 2.7.2
* Node.js version 14.15.4
* Rails version 6.1.3.1
* Yarn version 1.22.5
* PostgreSQL
* Redis


## Getting Started
To run this project on your local machine you have two options:
1. [Installation on your machine (Linux and Mac)](#1-Installation-on-your-machine-Linux-and-Mac).
2. [Install docker and run all services as containers](#2-Install-docker-and-run-all-services-as-containers).

## 1. Installation on your machine (Linux and Mac)

### Linux installation

- #### Install system dependencies
   The following dependencies are need to build the project. Type in your terminal de following commands to install:

     ```bash
     $ sudo apt-get update
     $ sudo apt-get install cmake
     $ sudo apt-get install pkg-config
     ```


- #### Install Node.js for Linux
	 Installing Node.js can be done in several ways, for example the most common is using `apt-get`:

     ```bash
     $ sudo apt-get install nodejs
     ```

     However using this command you wont be able to select a specific version for project, we need to use the **node.js version 14.15.4**, we encourage the use of a node version manager, for instance, [volta](https://volta.sh/) (to learn more about this tool check the link):

	```bash
    # Install Volta
    $ curl https://get.volta.sh | bash
	```

	> **You need to reopen your terminal to installation changes be applied and the volta commands can be recognized for node installation.**

	Install node with volta:

	```bash
	# Install Node
	$ volta install node@14.15.4

	# Check Node version
	$ node -v
	```


-   #### Install Ruby dependencies for Linux

    Clone the [rbenv](https://github.com/sstephenson/rbenv) repository (another good option is [`rvm`](https://rvm.io/)) from GitHub into the directory ~/.rbenv

    ```bash
    $ cd
    $ git clone https://github.com/rbenv/rbenv.git ~/.rbenv
    ```

    Next, add `~/.rbenv/bin` to your `$PATH` so that you can use the rbenv command line utility. Do this by altering your `~/.bashrc` file so that it affects future login sessions:

    ```bash
    $ echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
    $ echo 'eval "$(rbenv init -)"' >> ~/.bashrc
    $ source ~/.bashrc
    ```

    Verify that rbenv is set up properly by using the `type` command, which will display more information about the rbenv command:

    ```bash
    $ type rbenv
    ```

    Next, install the **ruby-build**, plugin. This plugin adds therbenv install command, which simplifies the installation process for new versions of Ruby:

    ```bash
    $ git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
    ```

    With the ruby-build plugin now installed, you can install versions of Ruby and may need through a simple command:

    ```bash
    # Install Ruby (this project use ruby version 2.7.2)
    $ rbenv install 2.7.2

	# Check ruby version
	$ ruby -v
    ```

    Turn off gem documentation

    ```bash
    $ echo "gem: --no-document" > ~/.gemrc
    ```


- #### Install Database for Linux
    Before continue creating the database, you might get an error creating it due to postgres, to avoid that we are going to install the PostgreSQL database and configure a user to manage it.

	The first thing you must do is configure the repositories lists:

	```bash
	$ wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
	$ echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" | sudo tee /etc/apt/sources.list.d/pgdg.list -
	$ sudo apt update -
	```

	Once the list of PostgreSQL packages is updated we will use the following command to install it:

	```bash
	$ sudo apt -y install postgresql-12 postgresql-client-12
	```

	Once PostgreSQL is installed, we will enter the session and create from there a new user with the ability to create databases:

    ```
    $ sudo -i -u postgres
    $ createuser --pwprompt --interactive (enter here the user name with out  () )
    $ Enter password for new role: ****** (your password)
    $ Enter it again: ******
    $ Shall the new role be a superuser? (y/n) y
    ```

    Make sure to save the **user** and **password** for later configurations, we will need that information laterTo exit the PostgreSQL session we must use the `exit` command.


- #### Redis installation and config for Linux
    Before doing migrate & seed to the database, you might get an error here due to Redis, to avoid this let's install and configurate Redis.

    ```bash
    $ sudo apt update
    $ sudo apt install redis-server
    ```

    This will download and install Redis and its dependencies. After this, there is a major configuration change to be made in the Redis configuration file, generated automatically during installation.

    ```bash
    $ sudo nano /etc/redis/redis.conf
    ```

    Find the `supervised` directive within the file. This directive allows you to declare an init system to manage Redis as a service, giving you more control over its operation. By default, the value of the `supervised` directive is `no`. Since this is Ubuntu, which uses the init system of systemd, change the value to `systemd`. Then it will be `supervised systemd`

    Then restart the Redis service to reflect the changes made to the configuration file:

    ```bash
    $ sudo systemctl restart redis.service
    ```

    And if everything it's ok, you'll see in **Loaded** the value of `enabled` and in **Active** you'll see `active (running)`.

	Go to [Final installation steps](#Final-installation-steps) section to finish the Rails configuration.



### Mac installation

Make sure you have [Homebrew](https://brew.sh/) installed before following the steps below. Homebrew allows us to install and compile software packages easily from source.

Homebrew comes with a very simple install script. When it asks you to **install XCode CommandLine Tools**, say **yes**.

Open Terminal and run the following command to install it:

```bash
$ ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

* #### Install cmake

	```
	$ brew install cmake
	```

* #### Install Node.js for Mac

	Installing Node.js can be done in several ways, we need to use the **node.js version 14.15.4**, we encourage the use of a node version manager, for instance, [volta](https://volta.sh/) (to learn more about this tool check the link):

	```bash
    # Install Volta
    $ curl https://get.volta.sh | bash
	```

	> **You need to reopen your terminal to installation changes be applied and the volta commands can be recognized for node installation.**

	Install node with volta:

	```bash
	# Install Node
	$ volta install node@14.15.4

	# Check Node version
	$ node -v
	```


- #### Install Ruby dependencies for Mac

	We're going to use  [rbenv](https://github.com/sstephenson/rbenv)  to install and manage our Ruby versions (another good option is [`rvm`](https://rvm.io/)). To do this, run the following commands in your Terminal:

	```bash
	# Install rbenv and ruby-build plugin
	$ brew install rbenv ruby-build

	# Add rbenv to bash so that it loads every time you open a terminal
	$ echo 'if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi' >> ~/.bash_profile
	$ source ~/.bash_profile

	# Install Ruby (this project use ruby version 2.7.2)
	$ rbenv install 2.7.2

	# Check ruby version
	$ ruby -v
	```

    Turn off gem documentation

    ```bash
    $ echo "gem: --no-document" > ~/.gemrc
    ```


- #### Install assets dependencies
    ```
    $ npm i -g yarn
    $ yarn install
    ```

	If you have [volta](#Install-Node.js) installed, also you can install `yarn` with volta like this:

	```bash
	# This project use yarn version 1.22.5
	$ volta install yarn@1.22.5
	```
- #### Setup pre-commit gem

	If you use **`rbenv`** run this:

    ```bash
    $ pre-commit install
    ```
	If you use **`rvm`** run the following command:

	```
	$ rvm default do gem install pre-commit
	```

- #### Install Database for Mac
    Before continue creating the database, you might get an error creating it due to postgres, to avoid that we are going to install the PostgreSQL database and configure a user to manage it.

	 * ##### With brew

	     Install postgres:

	    ```bash
	    $ brew install postgresql
	    ```

	    Start the postgres service:

	    ```bash
	    $ brew services start postgresql
	    ```

	    Run `initdb /usr/local/var/postgres` to check the username. Make sure to save the **username** and **password** for later configurations, we will need that information later.


   * ##### With PostgresApp

	  Follow the steps of the following link: [`https://postgresapp.com/`](https://postgresapp.com/)

	   Install the library that postgres needs:
	   ```bash
	   $ brew install libpq
	 ```

	   Setter postgres config file and pq lib dir that pg gem needs:
		```bash
		$ bundle config build.pg --with-pg-config=/Applications/Postgres.app/Contents/Versions/latest/bin/pg_config --with-pq-lib=/opt/homebrew/Cellar/libpq/13.3/lib
		```

	* ##### Docker alternative for Postgres

		Using postgres docker image is possible to have this service running locally:

		```bash
		$ docker run -p 5432:5432 -e POSTGRES_DB=ayenda_development -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=<ENTER-HERE-PASSWORD> -d postgres
		```

		Make sure to save the **username** and **password**, we will need that information for later configurations.



- #### Redis installation and config for Mac
    Before doing migrate & seed to the database, you might get an error here due to Redis, to avoid this let's install and configurate Redis.

    Install redis:

    ```bash
    $ brew install redis
    ```

    Start redis service:

    ```bash
    $ brew services start redis
    ```

	* ##### Docker alternative for Redis

		 Using redis docker image is possible to have this service running locally:

		```bash
		$ docker run -p 6379:6379 -d redis
		```

	Go to [Final installation steps](#Final-installation-steps) section to finish the Rails configuration.

### Final installation steps


- #### Install Bundler and Rails

	Run the following commands to install:

	```bash
	# Install Bundler
	$ gem install bundler

	# Install Rails (this project use rails 6.1.3.1)
	$ gem install rails -v 6.1.3.1
	```

	**If you use Rbenv**, in order to use the `rails` and `bundle` executables, you need to tell `rbenv` to see it:

	```bash
	$ rbenv rehash
	```

	Now you can verify Rails and Bundler are installed:

	```bash
	$ bundler -v
	# Bundler version

	$ rails -v
	# Rails 6.1.3.1
	```

- #### Clone repository
	Clone this repository to your local machine to finalize the file configurations. You must **have [Git](https://git-scm.com/) installed and configured** before this step.

	Type this in your terminal to clone the repo:

	```bash
	$ git clone https://github.com/AyendaHoteles/ayenda.git
	```


- #### Install app dependencies
    Make sure you have the correct version of ruby installed before running `bundle install` or it will generate errors.

    ```bash
    # Go to the cloned project directory
	$ cd ayenda

	# Install dependencies
    $ bundle install
    ```

- #### Setup config files

	We have include a Makefile file where there are useful commands for running steps quickly, e.g., the following command will do all the following setup steps of copying `master.key`, `credentials.yml.enc`, `database.yml`, `application.yml`, `openexchangerates_cache.json`, `puntos_colombia.p12`, `google_desktop_config.json` and `sidekiq.yml` config files and `tmp` and `viajala` folders.

	```bash
	$ make copy-config
	```

- #### Create DB and execute migrates, views and seeds (Not required if you have a db backup)

	First don't forget go to `config/database.yml` file and set the **username** & **password** that you created before for postgres in `development` and `test` configs, then,  execute commands below:

	```
	$ rails db:create
	$ rails db:migrate
	$ rails db:seed
	$ rails db:views
	```

- #### Run the webserver

	```
	$ rails s -p 3000
	=> Booting Puma
	=> Rails 6.1.3.1 application starting in development
	=> Run `bin/rails server --help` for more startup options
	Puma starting in single mode...
	* Puma version: 5.3.1 (ruby 2.7.2-p137) ("Sweetnighter")
	*  Min threads: 0
	*  Max threads: 5
	*  Environment: development
	*          PID: 74700
	* Listening on http://127.0.0.1:3000
	* Listening on http://[::1]:3000
	Use Ctrl-C to stop
	```

Now **everything has been installed**, you can jump to [How to access to the web server section](#how-to-access-to-the-web-server).


## 2. Install docker and run all services as containers

- ### Docker Desktop application

    * #### Linux

	    Install `docker-bin`, and `docker-compose-bin` on your system. Run using:

	    ```
	    $ systemctl start docker
	    ```

	    > **NOTE**: Linux installation steps may be different for your specific distro.

    * #### Mac and Windows

	    [Installation link](https://www.docker.com/products/docker-desktop) (requires to create an account)


- ### Build docker images

    ```bash
    $ docker-compose build
    ```
    Builds the containers for `server`, `db`, and `redis` specified in `docker-compose.yml`.


- ### Setup config files for Docker
    We have include a Makefile file where there are useful commands for running steps quickly, e.g., the following command will copy credentials, database, application and sidekiq config files.

    ```bash
    $ make docker-copy-config
    ```


- ### Update database
    ```
    $ docker-compose run server rails db:create
    $ docker-compose run server rails db:migrate
    $ docker-compose run server rails db:seed
    ```
    The commands above initialize the **Ayenda** development database and insert test data into it. Alternatively, you could run:
	```
	$ docker-compose run server rails db:reset
	```

- ### Running and Stopping
    ```
    $ docker-compose up
    ```
    Runs all the containers specified inside `docker-compose.yml`: `server`, `db`, and `redis`

    ```
    $ docker-compose down
    ```
    Stops all the containers specified inside `docker-compose.yml`: `server`, `db`, and `redis`

 Now **everything has been installed**, you can jump to [How to access to the web server section](#how-to-access-to-the-web-server).

- ### Attaching the console to a process for IO [or Debugging with Pry]
    The `$ docker-compose up` command uses a non-interactive console; since it won't read `stdin`, we need to attach another console to the specific container. To do this, open up a new console tab and run:

    ```bash
    $ docker attach --detach-keys="ctrl-x" CONTAINER_NAME
    ```

    The `--detach-keys` argument is passed to the command to allow detaching the console without killing the process that was attached. In this case pressing `CTRL+X` will detach the console without killing the process, but closing with `CTRL+C` will.

    The `CONTAINER_NAME` value can be obtained from the following command:

    ```bash
    $ docker-compose ps

        Name                   Command               State           Ports
    --------------------------------------------------------------------------------
    ayenda_db_1      docker-entrypoint.sh postgres    Up      0.0.0.0:4325->5432/tcp
    ayenda_redis_1   docker-entrypoint.sh redis ...   Up      0.0.0.0:3796->6379/tcp
    ayenda_server_1  entrypoint.sh bash -c rm - ...   Up      0.0.0.0:8000->8000/tcp
    ```

## How to access to the web server

### Setup hosts

   Update the file `/etc/hosts` (on **Linux**) or `/private/etc/hosts` (on **Mac**) to map AOS and PMS site to localhosts. Add following lines:

   ```ruby
   127.0.0.1 aos.local.co
   127.0.0.1 pms.local.co
   127.0.0.1 api.local.co
   127.0.0.1 ayenda.local.com
   127.0.0.1 db
   ```

   Go to the browser using port `3000` (for **docker** setup the port used is `8000`):

    http://aos.local.co:3000

    http://pms.local.co:3000



### "Save Emails and Attachments" chrome complement and Gmail
We have an integration with "Save Emails and Attachments" and Gmail, every 15 minutes is uploaded to Google Drive all pdf's sent by Rategain, this way we can capture CVV for autocollect reservations.
Link: [Save Emails and Attachments](https://chrome.google.com/webstore/detail/save-emails-and-attachmen/nflmnfjphdbeagnilbihcodcophecebc)



## Special Configurations

### FYI B2 Chat
The application's scheduler runs a job to request an access token everyday at 5:00 a.m. which is stored in the `Setting` table as `kind: b2_chat_access_token`, the actual access token is stored under the column `value`.

The client's secret is within the rails credentials file, which can be accessed via the following command:

```bash
$ EDITOR=nano rails credentials:edit
```
Make sure you have the proper master key, or else `rails credentials:edit` will create one.
In order to test the service, rails needs to point at the correct client secret, so under `non-production` section of the credentials file, change the dummy `b2chat_client_id`to the value in the `production`section

### FYI RateGain
For testing purposes, rategain supplied a test hotel for sending requests to https://rzhospicert.rategain.com/rgbridgeapi/ari/receive/ayenda. Therefore, **replace Hotel ID** for 17602 on the `xml` file. If this doesn't return success and everthing else seems to be in order, contact rategain support

### Electronic Billing

To setup your local environment and enable electronic billing testing and development, run the following command:

```bash
$ rails electronic_billing:setup
```

Remember that in order for this to work you must have at least one hotel from 'Bogotá'!

If you need to see more advanced configuration via UI:

  1. Go to https://sandbox.alegra.com
  2. For access to the sandbox environment:
		```
	  username: alianza
	  password: SandboxTesting!
		```

  3. For access to the actual account, use the email set by the rails task, the password can be found in the `credentials.yml.enc` file, under `alegra_sandbox_password`

In the account settings, it is possible to change all data **EXCEPT** the identification kind (NIT) and the identification number (900559088).

**¡WARNING!**: This environment is conected to Alegra's legal data in the DIAN database to ensure successful forwarding of the requests and have a similar response to `production` environment.

The current number template was given by the DIAN, and goes from 990007000 to 990008000; should we need more, please contact Alegra's development team.

## Wiki documentation

- ### Servers setup
    All the necessary steps to configure from scratch a server can be found here: https://github.com/AyendaHoteles/ayenda/wiki/Server

- ### Automatic deployments
    Automatic deploys are setup with Circle CI, to know more about it, read: https://github.com/AyendaHoteles/ayenda/wiki/Automatic-deployments

- ### Grafana and Prometheus
    Grafana can installed in a server following this guide: https://github.com/AyendaHoteles/ayenda/wiki/Grafana-and-Prometheus
