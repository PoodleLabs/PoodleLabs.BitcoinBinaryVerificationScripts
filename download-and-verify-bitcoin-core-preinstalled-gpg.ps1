# Make sure you run this script as an administrator!
param(
    # You may optinally run this script with the '-DownloadZip' flat to download a zip file containing the Bitcoin executables.
    # The default behaviour is to download and verify the setup instead.
    [switch]$DownloadZip=$false,

    # The version of Bitcoin Core which will be downloaded.
    [string]$CoreVersion = "25.0"
);

if ($DownloadZip)
{
    $downloadPath="https://bitcoincore.org/bin/bitcoin-core-$coreVersion/bitcoin-$coreVersion-win64.zip";
    $outputPath="./bitcoin-core-winx64.zip";
}
else
{
    $downloadPath="https://bitcoincore.org/bin/bitcoin-core-$coreVersion/bitcoin-$coreVersion-win64-setup.exe";
    $outputPath="./bitcoin-core-setup-winx64.exe";
}

# Download Bitcoin Core's setup, or zip file from BitcoinCore.org
Invoke-WebRequest -Uri $downloadPath -OutFile $outputPath;

$shaSumsFile = "./SHA256SUMS";
# Download Bitcoin Core's expected binary SHA256 hashes.
Invoke-WebRequest -Uri "https://bitcoincore.org/bin/bitcoin-core-$coreVersion/SHA256SUMS" -OutFile $shaSumsFile;

# Read the SHASUMS file
$shaSums = Get-Content -Path $shaSumsFile;

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

# Download the signatures.
$signatureFile = "./SHA256SUMS.asc";
Invoke-WebRequest -Uri "https://bitcoincore.org/bin/bitcoin-core-$coreVersion/SHA256SUMS.asc" -OutFile $signatureFile;

# Verify the signatures; you need to actually read the output here!
gpg --verify $signatureFile
