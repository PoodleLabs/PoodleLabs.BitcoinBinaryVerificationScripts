# Make sure you run this script as an administrator!
param(
    # You may optinally run this script with the '-DownloadZip' flat to download a zip file containing the Bitcoin executables.
    # The default behaviour is to download and verify the setup instead.
    [switch]$DownloadZip = $false,

    # The version of Bitcoin Core which will be downloaded.
    [string]$CoreVersion = "25.0",

    # The version of GPG 4 Win which will be downloaded, if GPG is not already installed.
    [string]$Gpg4WinVersion = "4.2.0"
);

# Check whether GPG is installed.
gpg --version

# Any error should just terminate the script from this point.
$ErrorActionPreference = "Stop";
if ($LASTEXITCODE -ne 0) {
    # Failed to run `gpg --version`; gpg is (probably) not installed.

    $downloadPath = "https://files.gpg4win.org/gpg4win-$Gpg4WinVersion.exe";
    $outputPath = "./gpg4win-$Gpg4WinVersion.exe";

    # Download Bitcoin Core's setup, or zip file from BitcoinCore.org
    Invoke-WebRequest -Uri $downloadPath -OutFile $outputPath;

    echo "Downloaded GPG 4 Win installer, located at '$outputPath'.";
    echo "Please check the file's certificate:"
    echo "    - Right click";
    echo "    - Select 'Properties'";
    echo "    - Open the 'Digital Certificates' tab";
    echo "    - Check the issuer is GlobalSign GCC R45 CodeSigning CA 2020";
    echo "Press any key to continue...";

    # Read a keypress and discard it.
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');

    # Start the installer for GPG 4 Win.
    Start-Process -NoNewWindow -Wait "$outputPath";

    # Refresh the PATH environment variable to make sure `gpg` will work in later calls.
    $Env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine");

    echo "Installed GPG4Windows.";
    echo "Please read the 'Keys' section of the README and install a certificate you trust for validating the Bitcoin Core binary releases.";
    echo "Press any key to continue...";

    # Read a keypress and discard it.
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
}

./download-and-verify-bitcoin-core-preinstalled-gpg.ps1 -DownloadZip $DownloadZip -CoreVersion $CoreVersion
