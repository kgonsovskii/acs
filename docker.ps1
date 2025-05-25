# Path to your solution folder containing projects
$srcFolder = "./src"

# Find all .csproj files under srcFolder
$allProjects = Get-ChildItem -Path $srcFolder -Recurse -Filter *.csproj

# Filter executable projects (<OutputType>Exe</OutputType>)
$exeProjects = @()
foreach ($proj in $allProjects) {
    $projContent = Get-Content $proj.FullName
    if ($projContent -match '<OutputType>Exe</OutputType>') {
        $projName = [System.IO.Path]::GetFileNameWithoutExtension($proj.Name)
        $exeProjects += [PSCustomObject]@{
            Name = $projName
            Path = $proj.FullName
        }
    }
}

if ($exeProjects.Count -eq 0) {
    Write-Error "No executable projects found!"
    exit 1
}

# Function to extract port from appsettings.json (or related config)
function Get-PortFromAppSettings($projectPath) {
    # Assume appsettings.json is next to csproj or in the project folder
    $projDir = Split-Path -Parent $projectPath
    $appSettingsPath = Join-Path $projDir "appsettings.json"

    if (-Not (Test-Path $appSettingsPath)) {
        # Try other common locations or return $null if not found
        Write-Warning "appsettings.json not found for project at $projDir"
        return $null
    }

    try {
        $jsonContent = Get-Content $appSettingsPath -Raw | ConvertFrom-Json
        $urls = $jsonContent."Urls"
        if (-not $urls) {
            # Maybe URLs are under Kestrel or other nested sections, or no Urls key
            return $null
        }

        # Example Urls value: "http://0.0.0.0:9993"
        # Extract port from URL string
        if ($urls -match ":(\d+)$") {
            return [int]$matches[1]
        }

        return $null
    }
    catch {
        Write-Warning "Failed to parse appsettings.json for project at $projDir"
        return $null
    }
}

# Build servicePorts map dynamically
$servicePorts = @{}

foreach ($proj in $exeProjects) {
    $port = Get-PortFromAppSettings $proj.Path

    if ($port -ne $null) {
        $servicePorts[$proj.Name] = $port
    }
    else {
         Write-Error "No valid port found in appsettings.json for project '$($proj.Name)'."
         exit 1
    }
}

# Show map for debug
Write-Host "`nDetected service ports:"
$servicePorts.GetEnumerator() | ForEach-Object { Write-Host "  $($_.Key) => $($_.Value)" }

# Stop and remove running containers
foreach ($proj in $exeProjects) {
    $containerName = "acs-" + $proj.Name.ToLower()
    $existing = docker ps -q -f "name=$containerName"
    if ($existing) {
        Write-Host "Stopping and removing container: $containerName ..."
        docker stop $containerName | Out-Null
        docker rm $containerName | Out-Null
    }
}

# Publish each exe project
foreach ($proj in $exeProjects) {
    Write-Host "`n📦 Publishing project '$($proj.Name)' (self-contained)..."
    dotnet publish $proj.Path `
        -c Release `
        -r linux-x64 `
        --self-contained true `
        -o "./publish/$($proj.Name)"
}

# Build Docker images for each project
foreach ($proj in $exeProjects) {
    $imageName = "acs-" + $proj.Name.ToLower()
    $tag = $imageName + ":latest"
    Write-Host "`n🐳 Building Docker image for project '$($proj.Name)' with image name '$tag'..."
    docker build --build-arg PROJECT_NAME=$($proj.Name) -t $tag .
}



# Generate docker-compose.gen.yml
$genYaml = @()
$genYaml += "version: '3.9'"
$genYaml += ""
$genYaml += "services:"

foreach ($proj in $exeProjects) {
    $nameLower = $proj.Name.ToLower()
    $port = $servicePorts[$proj.Name]
    $portPort = "$port" +":" + "$port"
    $image = "acs-$nameLower" + ":latest"
    $genYaml += "  $nameLower" + ":"
    $genYaml += "    build:"
    $genYaml += "      context: ."
    $genYaml += "      args:"
    $genYaml += "        PROJECT_NAME: $($proj.Name)"
    $genYaml += "    image: $image"
    $genYaml += "    ports:"
    $genYaml += "      - `"$portPort`""
    $genYaml += "    environment:"
    $genYaml += "      - ASPNETCORE_ENVIRONMENT=Production"
    $genYaml += ""
}

$genYaml | Set-Content -Path "./docker-compose.gen.yml" -Encoding UTF8

# Run Compose using base + generated file
Write-Host "`n🚀 Starting all services..."
docker-compose -f docker-compose.base.yml -f docker-compose.gen.yml up -d


# Show running containers
Write-Host "`n✅ Running containers:"
foreach ($proj in $exeProjects) {
    $imageName = "acs-" + $proj.Name.ToLower()
    docker ps -f "ancestor=$imageName:latest"
}
