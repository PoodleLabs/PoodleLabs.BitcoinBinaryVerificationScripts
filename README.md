# Bitcoin Core Verification Script

This repository contains a Windows PowerShell script which automatically installs Chocolatey package manager, installs GPG4Win via Chocolatey, downloads the current (or specified version) of Bitcoin Core (by default, the setup executable, optionally the zip file), the expected SHA256 hash for each file, the signatures file for the hashes, and calls `gpg --verify`.

## Usage

1. Open PowerShell as an administrator.
2. Download this repository, either via `git clone https://github.com/PoodleLabs/PoodleLabs.BitcoinBinaryVerificationScripts`, or by downloading and extracting a zip file of the current source code via the GitHub UI (in the case of downloading a zip file, extract it somewhere).
3. Type `cd [PATH TO REPOSITORY]` where `[PATH TO REPOSITORY]`is the fully qualified directory name for your local copy of the repository, for example `cd C:/users/Isaac/downloads/PoodleLabs.BitcoinBinaryVerificationScripts`.
4. Type `download-and-verify-bitcoin-core.ps1`. Optionally you may add the `DownloadZip` flag (eg: `download-and-verify-bitcoin-core.ps1 -DownloadZip`) to download a zip file containing the Bitcoin Core binaries, rather than installer, and you may specify a Bitcoin Core version with the `CoreVersion` flag (eg: `download-and-verify-bitcoin-core.ps1 -CoreVersion "24.0"`).
5. Read the output.

You will need to import one or more Bitcoin Core contributors' keys. To do this, run the script once to ensure GPG4Win is installed, obtain some `.gpg` files for the developers whose keys you want to use (this repository's `keys` folder contains a mirror of the keys contained in https://github.com/bitcoin-core/guix.sigs/tree/main/builder-keys; please read the [readme](./keys/README.md) if you intend on using them), and run `gpg --import [FULLY QUALIFIED FILE PATH FOR THE KEY YOU WANT TO IMPORT]` (eg: `gpg --import ./keys/achow101.gpg` from this directory), then run the script again and verify the signatures pass for each key you imported. For example, if you imported Andrew Chow's key, the output of the script should include `Good signature from "Andrew Chow <andrew@achow101.com>"`.