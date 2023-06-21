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

