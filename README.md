# Mongodb S3 backupper
A tool that allows you to dump, archive, encrypt and upload a MongoDB NoSQL database to any S3 compliant bucket with the ease of a couple of environment variables. You can deploy it on Docker (either standalone or Docker Compose), or just run it directly.
## Table Of Contents
- [Mongodb S3 backupper](#mongodb-s3-backupper)
	- [Table Of Contents](#table-of-contents)
	- [Purpose](#purpose)
	- [Stack](#stack)
	- [Docker support?](#docker-support)
	- [Environment variables](#environment-variables)
	- [Contributing](#contributing)
	- [License](#license)

## Purpose
When it comes to databases, I don't really trust them. Backups are always necessary but when we're talking about storing irreplaceable and confidential data, I feel like they're extra relevant. This was the mindset behind this tool: to help me securely and effortlessly archive MongoDB databases.

## Stack
The stack is extremely simple, since not much is required for what we're trying to achieve:
- [Bash](https://en.wikipedia.org/wiki/Bash_(Unix_shell))
- [MongoDB tools](https://www.mongodb.com/try/download/database-tools)
- [aws-cli](https://aws.amazon.com/cli/)
- [gpg](https://gnupg.org/)

## Docker support?
Yes, there is docker support. The `Dockerfile` should be fully buildable and the `docker-compose.yml` file should work with a valid `.env`. More on that later.

## Environment variables
| Variable                | Value                                                        |
|-------------------------|--------------------------------------------------------------|
| MONGODUMP_S3_ENDPOINT   | URL of the S3 endpoint                                       |
| MONGODUMP_S3_BUCKET     | Target S3 bucket you want to use                             |
| MONGODUMP_S3_KEY_PREFIX | S3 prefix/directory under which the archive will be uploaded |
| MONGODUMP_S3_ACCESS_KEY | S3 access key (used for authorization)                       |
| MONGODUMP_S3_SECRET_KEY | S3 secret key (used for authorization)                       |
| MONGODUMP_GPG           | Complete path of the target GPG public key                   |
| MONGODUMP_URI           | The MongoDB URI of the database in question                  |
| MONGODUMP_SLEEP         | Every how long should the archiving occur? (s,m,h,d)         |