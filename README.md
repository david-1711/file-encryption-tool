# File Encryption Tool

## Overview

[securefile.sh](securefile.sh) is a Bash script that leverages Argon2id to create complex hash value of entered password and OpenSSL to encrypt and decrypt the selected file by using the calculated hash. This way we create quite complex password for encryption and decryption. The hash value generated varies depending on the Argon settings. Consequently, it's essential to employ identical settings for both encryption and decryption processes.

## Features

- **Argon2 Password Hashing:** Uses Argon2(https://en.wikipedia.org/wiki/Argon2), the winner of the Password Hashing Competition, to derive encryption keys from passwords.
- **File Encryption:** Encrypts files using AES-256-CBC, a strong symmetric encryption algorithm.
- **File Decryption:** Decrypts previously encrypted files with the correct password.
- **Simple Interface:** Easy to use command-line interface for both encryption and decryption.

## Requirements

- **argon2:** Install Argon2 password hashing tool.
- **openssl:** Install OpenSSL cryptographic toolkit.

## Installation

1. Ensure `argon2` and `openssl` are installed on your system.
   - On Ubuntu, you can install them with:
     ```bash
     sudo apt-get install argon2 openssl
     ```
   - On macOS, you can install them with Homebrew:
     ```bash
     brew install argon2 openssl
     ```

2. Clone this repository and make the script executable:
   ```bash
   git clone https://github.com/david-1711/file-encryption-tool.git
   cd file-encryption-tool
   chmod +x securefile.sh

## Usage

The script accepts the following command-line arguments:
- `encrypt <file>`: Encrypt the specified file.
- `decrypt <file>`: Decrypt the specified file.

### Encrypt a file
    ./securefile.sh encrypt yourfile.txt

### Decrypt a file

    ./securefile.sh decrypt yourfile.txt.enc

## Argon2 Settings

When running the script, there will be prompt to enter Argon2 settings. It is possible to press Enter to use the default values:

- **Iterations (default: 20):** The number of iterations to perform.
- **Memory usage in KiB (default: 10000):** The amount of memory to use.
- **Number of threads (default: 5):** The number of threads to use.
- **Hash length (default: 64):** The length of the generated hash.

## License

This project is licensed under the Unlicense - see the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request.

## Author

Created by David Tkalčec.

## Acknowledgments

- Uses [Argon2](https://github.com/P-H-C/phc-winner-argon2) for password hashing.
- Uses [OpenSSL](https://www.openssl.org/) for encryption and decryption.
