**NOTE: PoodleLabs is moving homes to a self-hosted GitHub alternative; these repositories have been left up for posterity, and will not be updated**

# Bitcoin Core Verification Script

This repository contains a Windows PowerShell script which installs GPG4Win (default: v4.2.0), downloads Bitcoin Core (by default, the setup executable, optionally the zip file, defaults to v25.0), the expected SHA256 hash for each file, the signatures file for the hashes, and calls `gpg --verify`.

## Keys

You will need to import one or more Bitcoin Core contributors' keys. To do this, run the script to ensure GPG4Win is installed and when prompted to read this section, obtain some `.gpg` files for the developers whose keys you want to use (this repository's `keys` folder contains a mirror of the keys contained in https://github.com/bitcoin-core/guix.sigs/tree/main/builder-keys; please read the [readme](./keys/README.md) if you intend on using them), and run `gpg --import [FULLY QUALIFIED FILE PATH FOR THE KEY YOU WANT TO IMPORT]` (eg: `gpg --import ./keys/achow101.gpg` from this directory), then continue the execution of the script and verify the signatures pass for each key you imported. For example, if you imported Andrew Chow's key, the output of the script should include `Good signature from "Andrew Chow <andrew@achow101.com>"`.

You should compare the script with the content under `Windows verification instructions` at https://bitcoincore.org/en/download/.

Remember: blindly running this script is not verification. You're simply trusting me, the author, unless you actually *check* what it's doing. The script ([1](https://github.com/PoodleLabs/PoodleLabs.BitcoinBinaryVerificationScripts/blob/master/download-and-verify-bitcoin-core.ps1), [2](https://github.com/PoodleLabs/PoodleLabs.BitcoinBinaryVerificationScripts/blob/master/download-and-verify-bitcoin-core-preinstalled-gpg.ps1)) is documented almost line by line, and if you have *any* questions about what a particular line is doing, you should raise an issue.

## Usage

1. Open PowerShell as an administrator.
2. Download this repository, either via `git clone https://github.com/PoodleLabs/PoodleLabs.BitcoinBinaryVerificationScripts`, or by downloading and extracting a zip file of the current source code via the GitHub UI (in the case of downloading a zip file, extract it somewhere).
3. Enable scripts for the current process with `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process` and confirm.
4. Type `cd [PATH TO REPOSITORY]` where `[PATH TO REPOSITORY]`is the fully qualified directory name for your local copy of the repository, for example `cd C:/users/Isaac/downloads/PoodleLabs.BitcoinBinaryVerificationScripts`.
4. Type `download-and-verify-bitcoin-core.ps1`. Optionally you may add the `DownloadZip` flag (eg: `download-and-verify-bitcoin-core.ps1 -DownloadZip`) to download a zip file containing the Bitcoin Core binaries, rather than installer, and you may specify a Bitcoin Core version with the `CoreVersion` flag (eg: `download-and-verify-bitcoin-core.ps1 -CoreVersion "24.0"`), or a GPG 4 Win version with the `Gpg4WinVersion` flag (note: this will only do something if GPG is not already installed and on your path). 
5. Read the output.

### Notes
- If you already have GPG4Win installed, you may run the `download-and-verify-bitcoin-core-preinstalled-gpg.ps1` script instead, with the same arguments sans `Gpg4WinVersion`.
- This script can be used on Linux if you have powershell installed, but will download Windows executables; it could be used on a Linux system to download and verify the Core executable or portable zip file for use on a Windows installation, but the GPG auto-installation will (obviously) not work. You can install GPG with your normal package manager, eg: `sudo apt install gpg`.


## Contributions

Contributions are welcome. Improvements to existing content, as well as additional scripts which fit in this repository (eg: the same thing for other operating systems). I intend to add more at some point, but given those who most need this script are likely using Windows, I feel this is a good starting point.
