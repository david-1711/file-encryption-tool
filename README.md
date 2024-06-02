# File Encryption Tool

## Overview

The [securefile.sh](securefile.sh) is a Bash script designed to encrypt and decrypt individual files containing sensitive data. It utilizes Argon2id to generate a complex encryption password (hash) from a user-provided password (master key), making the password highly resistant to brute-force attacks. The hash value generated varies depending on the Argon settings. Consequently, it's essential to employ identical settings for both encryption and decryption processes. Argon2id is the winner of the Password Hashing Competition and is designed to be computationally intensive and memory-hard, providing robust protection against both offline and parallel brute-force attacks.

By using Argon2id, the script ensures that even if an attacker attempts to brute-force the master key, the process is significantly slower compared to directly using the master key for encryption. This added layer of security comes from Argon2id's configurable settings, such as iterations, memory usage, and parallelism, which can be adjusted to increase the difficulty of brute-force attempts.

Other benefits of using Argon2id include:

- **Adaptive Resistance:** Argon2id's settings can be fine-tuned to adapt to advancements in hardware, maintaining strong security over time.
- **Memory-Hard Function:** Argon2id requires a significant amount of memory, making it difficult for attackers to use specialized hardware like GPUs and ASICs to speed up brute-force attacks.
- **Parallel Processing:** The algorithm's parallelism allows it to leverage multiple CPU cores, enhancing performance while maintaining security.

In summary, [securefile.sh](securefile.sh) encrypts files with a strong encryption algorithm (AES-256-CBC via OpenSSL) and ensures that the derived encryption key is highly secure, thanks to Argon2id. This makes it an great tool for protecting sensitive data with state-of-the-art cryptographic practices.

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
