#!/bin/bash

set -eou pipefail
LOG_FILE="/tmp/file-encrpytion-tool.log"

echo "
  ___ _ _       ___                       _   _            _____         _ 
 | __(_) |___  | __|_ _  __ _ _ _  _ _ __| |_(_)___ _ _   |_   _|__  ___| |
 | _|| | / -_) | _|| ' \/ _| '_| || | '_ \  _| / _ \ ' \    | |/ _ \/ _ \ |
 |_| |_|_\___| |___|_||_\__|_|  \_, | .__/\__|_\___/_||_|   |_|\___/\___/_|
                                |__/|_|
"

usage() {
  echo "Usage: $0 encrypt|decrypt <file>"
  echo "  encrypt <file> : Encrypt the specified file"
  echo "  decrypt <file> : Decrypt the specified file"
  exit 1
}

if [ $# -ne 2 ]; then
  usage
fi

ACTION=$1
FILE=$2

if [ "$ACTION" != "encrypt" ] && [ "$ACTION" != "decrypt" ]; then
  usage
fi

if [ ! -f "$FILE" ]; then
  echo "ERROR: Selected file $FILE does not exist."
  exit 1
fi

echo "Checking if argon2 and openssl are installed..."
if ! which argon2 > /dev/null; then
  echo "ERROR: argon2 is not installed."
  echo "Run \"sudo apt install argon2\" and try again."
  exit 1
else
  echo "argon2 => OK"
fi
if ! which openssl > /dev/null; then
  echo "ERROR: openssl is not installed."
  echo "Run \"sudo apt install openssl\" and try again."
  exit 1
else
  echo "openssl => OK"
fi

echo -e "\n############################### Argon2id key derivation function #############################################"

read -r -s -p "Enter master password: " MASTER_PASS
echo ""
read -r -s -p "Enter salt: " SALT
echo ""

# Default Argon settings
## see OWASP recomendadions: https://cheatsheetseries.owasp.org/cheatsheets/Password_Storage_Cheat_Sheet.html)
DEFAULT_ITER=20
DEFAULT_MEM_USG=100000 # KiB
DEFAULT_THREADS=4
DEFAULT_HASH_LENGHT=64

# Prompt for Argon settings
echo "Starting configuration of Argon2id parameters..."
read -r -p "Enter iterations (default: $DEFAULT_ITER): " ITER
ITER=${ITER:-$DEFAULT_ITER}

read -r -p "Enter memory usage in KiB (default: $DEFAULT_MEM_USG): " MEM_USG
MEM_USG=${MEM_USG:-$DEFAULT_MEM_USG}

read -r -p "Enter number of threads (default: $DEFAULT_THREADS): " THREADS
THREADS=${THREADS:-$DEFAULT_THREADS}

read -r -p "Enter hash length (default: $DEFAULT_HASH_LENGHT): " HASH_LENGHT
HASH_LENGHT=${HASH_LENGHT:-$DEFAULT_HASH_LENGHT}

echo ""

echo -n "${MASTER_PASS}" | \
  argon2 "${SALT}" \
    -id \
    -t "${ITER}" \
    -k "${MEM_USG}" \
    -p "${THREADS}" \
    -l "${HASH_LENGHT}" | tee $LOG_FILE

ENCRYPTION_KEY="$(grep Encoded: $LOG_FILE | cut -d "$" -f6)"
ARGON2_VERSION="$(grep Encoded: $LOG_FILE | cut -d "$" -f3)"

echo -e "\nType: $(grep "Encoded:" $LOG_FILE | cut -d "$" -f2)"
echo "Argon2 version: ${ARGON2_VERSION}"
echo "Memory, iterations, threads: $(grep Encoded: $LOG_FILE | cut -d "$" -f4)"
echo "Salt(base64 encoded): $(grep Encoded: $LOG_FILE | cut -d "$" -f5)"
echo "Salt(base64 decoded): $(grep Encoded: $LOG_FILE | cut -d "$" -f5 | base64 --decode 2>/dev/null)"
echo "Encoded hash: $ENCRYPTION_KEY"
rm -f $LOG_FILE

echo -e "\n############################### Running Openssl ##############################################################"

OPENSSL_ARGS="-v -pbkdf2 -aes-256-cbc -pass pass:$ENCRYPTION_KEY"
echo "===> OPENSSL ARGUMENTS: $OPENSSL_ARGS"

if [[ ${ACTION} == encrypt ]]; then
  echo -e "\nUsing Argon2id derivated hash as a password for encryption.\n"

  echo "===> OPENSSL COMMAND: openssl enc $OPENSSL_ARGS -in $FILE -out $FILE.enc"
  if openssl enc $OPENSSL_ARGS -in "$FILE" -out "$FILE".enc; then
    echo "Encrypted file: $FILE.enc"
  else
    echo "ERROR: Encryption failed"
    exit 1
  fi
elif [[ ${ACTION} == decrypt ]]; then
  echo "===> OPENSSL COMMAND: openssl enc -d $OPENSSL_ARGS -in $FILE -out ${FILE%.*}.dec"
  if openssl enc -d $OPENSSL_ARGS -in "$FILE" -out "${FILE%.*}".dec; then
    echo "Decrypted file: ${FILE%.*}.dec"
  else
    echo "ERROR: Decryption failed."
    exit 1
  fi
else
  echo -e "ERROR: openssl mode not selected. Set script argument to \"encrypt\" or \"decrypt\""
  exit 1
fi

echo ""
echo "############## SECRET DATA THAT SHOULD BE WRITTEN SOMEWHERE OFFLINE ##############################################"
echo "#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!#"
echo "#  1. master password"
echo "#  2. salt"
echo "#  3. argon parameters: echo -n <master password> | argon2 <salt> -id -t ${ITER} -k ${MEM_USG} -p ${THREADS} -l ${HASH_LENGHT}"
echo "#  4. openssl parameters: ${OPENSSL_ARGS%pass:*}:hashDerivatedByArgon2id"
echo "#  5. argon version:   ${ARGON2_VERSION}"
echo "#  6. openssl version: $(openssl version)"
echo "#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!#"
echo "############## SECRET DATA THAT SHOULD BE WRITTEN SOMEWHERE OFFLINE ##############################################"
