#!/bin/bash

# Copyright MalwarePad Productions 2016 - 2023

# Least complicated bash code regarding colors (i absolutely love this language (lie))
nc='\033[0m'
red='\033[0;31m'
blue='\033[0;34m'
green='\033[0;32m'

use_s3() {
	S3_KEY="${MONGODUMP_S3_KEY_PREFIX}/${1}"

	aws configure set aws_access_key_id "$MONGODUMP_S3_ACCESS_KEY"
	aws configure set aws_secret_access_key "$MONGODUMP_S3_SECRET_KEY"

	aws s3 --endpoint-url "$MONGODUMP_S3_ENDPOINT" cp "$1" "s3://$MONGODUMP_S3_BUCKET/$S3_KEY"
}

check_command() {
	if ! command -v "$1" &>/dev/null; then
		echo -e "${red}The $1 binary cannot be found/executed!${nc}"
		exit 1
	fi
}

check_command "mongodump"
check_command "zip"
check_command "gpg"
check_command "aws"

[[ -z "${MONGODUMP_URI}" || -z "${MONGODUMP_SLEEP}" || -z "${MONGODUMP_S3_ACCESS_KEY}" || -z "${MONGODUMP_S3_SECRET_KEY}" || -z "${MONGODUMP_S3_ENDPOINT}" || -z "${MONGODUMP_S3_BUCKET}" || -z "${MONGODUMP_S3_KEY_PREFIX}" ]] &&
	{
		echo -e "${red}Invalid environment detected!${nc}"
		exit 1
	}

[[ ! -f "${MONGODUMP_GPG}" ]] &&
	{
		echo -e "${red}No public key to do the encryption against!${nc}"
		exit 1
	}

while :; do
	EXPORT_NAME=$(date "+%F-%T")
	echo -e "${blue}Export ${EXPORT_NAME} was initiated...${nc}"
	if mongodump --uri "${MONGODUMP_URI}" --out "./out"; then # dumping
		# Zipping
		echo -e "${blue}Export ${EXPORT_NAME} is being zipped...${nc}"
		zip -rm "${EXPORT_NAME}.zip" out/

		# Encryption
		echo -e "${blue}Export ${EXPORT_NAME} is being encrypted...${nc}"
		gpg --recipient-file "${MONGODUMP_GPG}" --encrypt "${EXPORT_NAME}.zip"
		rm "${EXPORT_NAME}.zip"

		# Uploading
		echo -e "${blue}Export ${EXPORT_NAME} is being uploaded to s3...${nc}"
		use_s3 "${EXPORT_NAME}.zip.gpg"

		# Cleanup
		rm "${EXPORT_NAME}.zip.gpg"

		echo -e "${green}Export ${EXPORT_NAME} succeeded!${nc}"
	else
		echo -e "${red}Export ${EXPORT_NAME} failed!${nc}"
		exit 1
	fi
	echo -e "${blue}Waiting ${MONGODUMP_SLEEP} before running again...${nc}"
	sleep "${MONGODUMP_SLEEP}"
done
