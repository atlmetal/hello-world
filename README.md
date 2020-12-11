# SETUP PROJECT

## LOCAL DEVELOPMENT ENVIRONMENT (no docker)

### Install system dependencies
Mac:

```
brew install cmake
```

Linux:
```
sudo apt-get update
sudo apt-get install cmake
sudo apt-get install pkg-config
sudo apt-get install nodejs
```

### Install app dependencies:
```
bundle install
```
If after run `~ bundle install` it shows you `rbenv: version `2.6.5' is not installed` just run: `~ rbenv install 2.6.5` then try again:  `~ bundle install`.
After get bundle installed, you may get a warning message: "Warning: the running version of Bundler (1.17.2) is older than the version that created the lockfile (1.17.3). We suggest you upgrade to the latest version of Bundler by running `~ gem install bundler`."


### Install assets dependencies:
```
npm i -g yarn
yarn install
```
### Setup pre-commit gem
```
pre-commit install
```

### Setup Credentials file
```
cp config/master.key.example config/master.key
cp config/credentials.yml.enc.example config/credentials.yml.enc
```

Copy all .example files from config/third_keys/ and paste without that extension.

### Setup Database
```
cp config/database.yml.example config/database.yml
```

### Setup Application environment variables
```
cp config/application.yml.example config/application.yml
```

### Setup sidekiq
```
cp config/sidekiq.yml.example config/sidekiq.yml
```

### Create Database
```
rails db:create
```

### Migrate & Seed (Not required if you have a db backup)
```
rails db:migrate
```

```
rails db:seed
```
### Run the webserver:
```
rails start
```

## LOCAL DEVELOPMENT ENVIRONMENT (with docker)

### Requirements

- Docker Desktop application:
    * MAC & Windows [here](https://www.docker.com/products/docker-desktop) (requires to create an account)

    * Linux: Install `docker-bin`, and `docker-compose-bin` on your system. Run using
    ```
    systemctl start docker
    ```
    NOTE: Linux installation steps may be different for your specific distro.

### Initial setup

```
$ docker-compose build
```
Builds the containers for `web`, `db`, and `redis` specified in `docker-compose.yml`.

```
$ docker-compose run web rails db:create
$ docker-compose run web rails db:migrate
$ docker-compose run web rails db:seed
```
The commands above initialize the **Ayenda** development database and insert test data into it.

Alternatively, you could run `$ docker-compose run web rails db:reset`.

### Running and Stopping

```
$ docker-compose up
```
Runs all the containers specified inside `docker-compose.yml`: `web`, `db`, and `redis`

```
$ docker-compose down
```
Runs all the containers specified inside `docker-compose.yml`: `web`, `db`, and `redis`

### Attaching the console to a process for IO [or Debugging with Pry]

The `$ docker-compose up` command uses a non-interactive console; since it won't read `stdin`, we need to attach another console to the specific container. To do this, open up a new console tab and run:

```
$ docker attach --detach-keys="ctrl-x" CONTAINER_NAME
```
The `--detach-keys` argument is passed to the command to allow detaching the console without killing the process that was attached. In this case pressing `CTRL+X` will detach the console without killing the process, but closing with `CTRL+C` will.

The `CONTAINER_NAME` value can be obtained from the following command:
```
$ docker-compose ps

     Name                   Command               State           Ports
--------------------------------------------------------------------------------
ayenda_db_1      docker-entrypoint.sh postgres    Up      0.0.0.0:4325->5432/tcp
ayenda_redis_1   docker-entrypoint.sh redis ...   Up      0.0.0.0:3796->6379/tcp
ayenda_web_1     entrypoint.sh bash -c rm - ...   Up      0.0.0.0:3000->3000/tcp
```


## ACCESING THE WEB SERVER

### Setup /etc/hosts (on Linux) or /private/etc/hosts (on Mac) to map AOS and PMS site to localhosts. Add following lines:
    127.0.0.1 aos.local.co
    127.0.0.1 pms.local.co
    127.0.0.1 api.local.co
    127.0.0.1 ayenda.local.com
    127.0.0.1 db

and get in the browser using port 3000: aos.local.co:3000 or pms.local.co:3000


## "Save Emails and Attachments" chrome complement and Gmail
We have an integration with "Save Emails and Attachments" and Gmail, every 15 minutes is uploaded to Google Drive all pdf's sent by Rategain, this way we can capture CVV for autocollect reservations.
Link: [Save Emails and Attachments](https://chrome.google.com/webstore/detail/save-emails-and-attachmen/nflmnfjphdbeagnilbihcodcophecebc)

![Build Status](<project_url>/badges/<branch_name>/build.svg)

### FYI B2 Chat
The application's scheduler runs a job to request an access token everyday at 5:00 a.m. which is stored in the `Setting` table as `kind: b2_chat_access_token`, the actual access token is stored under the column `value`.

The client's secret is within the rails credentials file, which can be accessed via the following command
```
EDITOR=nano rails credentials:edit
```
Make sure you have the proper master key, or else `rails credentials:edit` will create one.
In order to test the service, rails needs to point at the correct client secret, so under `non-production` section of the credentials file, change the dummy `b2chat_client_id`to the value in the `production`section

### FYI RateGain
For testing purposes, rategain supplied a test hotel for sending requests to 'https://rzhospicert.rategain.com/rgbridgeapi/ari/receive/ayenda'. Therefore, replace Hotel ID for 17602 on the xml file. If this doesn't return success and everthing else seems to be in order, contact rategain support

### Integration files
Viajala hotels and locations feed file
```
mkdir tmp/viajala/
```
