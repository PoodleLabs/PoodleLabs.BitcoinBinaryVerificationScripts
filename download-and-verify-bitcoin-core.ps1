# Make sure you run this script as an administrator!
param(
    # You may optinally run this script with the '-DownloadZip' flat to download a zip file containing the Bitcoin executables.
    # The default behaviour is to download and verify the setup instead.
    [switch]$DownloadZip=$false
);

# Check whether Chocolatey is installed.
choco --version
if ($LASTEXITCODE -ne 0) 
{
    # The choco command line couldn't be called; install Chocolatey, a package management tool for Windows.
    # For more information, see: https://chocolatey.org/install
    Set-ExecutionPolicy Bypass -Scope Process -Force;
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'));

    if ($LASTEXITCODE -ne 0) 
    { # Chocolatey installation failed.
        echo "Failed to install chocolatey. Please raise an issue in the GitHub repository containing this script.";
        return $LASTEXITCODE;
    }
}

choco install -y gpg4win
if ($LASTEXITCODE -ne 0)
{ # GPG installation failed.
    echo "Failed to install GPG. Please raise an issue in the GitHub repository containing this script.";
    return $LASTEXITCODE;
}

if ($DownloadZip)
{
    $downloadPath="https://bitcoincore.org/bin/bitcoin-core-25.0/bitcoin-25.0-win64.zip";
    $outputPath="./bitcoin-core-winx64.zip";
}
else
{
    $downloadPath="https://bitcoincore.org/bin/bitcoin-core-25.0/bitcoin-25.0-win64-setup.exe";
    $outputPath="./bitcoin-core-setup-winx64.exe";
}

# Download Bitcoin Core's setup, or zip file from BitcoinCore.org
Invoke-WebRequest -Uri $downloadPath -OutFile $outputPath;
if ($LASTEXITCODE -ne 0)
{ # Bitcoin Core download failed.
    echo "Failed to download Bitcoin Core. Please raise an issue in the GitHub repository containing this script.";
    return $LASTEXITCODE;
}

$shaSumsFile = "./SHA256SUMS";
# Download Bitcoin Core's expected binary SHA256 hashes.
Invoke-WebRequest -Uri "https://bitcoincore.org/bin/bitcoin-core-25.0/SHA256SUMS" -OutFile $shaSumsFile;
if ($LASTEXITCODE -ne 0)
{ # Bitcoin Core SHASUMS download failed.
    echo "Failed to download Bitcoin Core SHASUMS. Please raise an issue in the GitHub repository containing this script.";
    return $LASTEXITCODE;
}

# Read the SHASUMS file
$shaSums = Get-Content -Path $shaSumsFile;
if ($LASTEXITCODE -ne 0)
{ # Failed to read Bitcoin Core SHASUMS.
    echo "Failed to read Bitcoin Core SHASUMS. Please raise an issue in the GitHub repository containing this script.";
    return $LASTEXITCODE;
}

if ($DownloadZip)
{
    $shaSumIndex = 26;
}
else
{
    $shaSumIndex = 22;
}

# Read the expected hash for the downloaded file.
$shaSum = $shaSums[$shaSumIndex].Split(" ")[0];


# Hash the downloaded file.
$hash = (Get-FileHash -Path $outputPath -Algorithm "SHA256").Hash;

# Compare the actual hash with the expected hash.
if ($shaSum -ne $hash) {
    # The hashes don't match!
    echo "Expected filehash '$shaSum', got '$hash'. Something is wrong; either you've fallen victim to an attack, or something is broken in the script for your environment. Please raise an issue in the GitHub repository containing this script.";
    return $LASTEXITCODE;
}
else {
    # Print the hash for your convenience.
    echo "The file hash is '$hash'.";
}