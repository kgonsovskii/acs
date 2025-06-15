# Load Rider automation API
$rider = [System.Runtime.InteropServices.Marshal]::GetActiveObject("JetBrains.Rider.DTE")
if ($null -eq $rider) {
    Write-Host "Rider is not running. Please open the solution in Rider first."
    exit 1
}

# Get the solution
$solution = $rider.Solution
if ($null -eq $solution) {
    Write-Host "No solution is open in Rider."
    exit 1
}

# Define the folder structure
$folders = @{
    "Api" = @("Api")
    "Atlas" = @("Atlas", "Atlas.Client", "Atlas.Component", "Atlas.Model", "Atlas.Tests")
    "Chronicle" = @("Chronicle", "Chronicle.Client", "Chronicle.Model", "Chronicle.Tests")
    "Codex" = @("Codex", "Codex.Client", "Codex.Component", "Codex.Model", "Codex.Tests")
    "Contour" = @("Contour", "Contour.Client", "Contour.Component", "Contour.Model", "Contour.Tests")
    "Logic" = @("Logic", "Logic.Client", "Logic.Component", "Logic.Model", "Logic.Tests")
    "Person" = @("Person", "Person.Client", "Person.Model", "Person.Tests")
    "Shared" = @("Shared", "Shared.Api", "Shared.App", "Shared.Db", "Shared.Tests")
}

# Create solution folders and move projects
foreach ($folder in $folders.Keys) {
    Write-Host "Creating folder: $folder"
    $solutionFolder = $solution.AddSolutionFolder($folder)
    
    foreach ($project in $folders[$folder]) {
        Write-Host "  Moving project: $project"
        $projectItem = $solution.Projects | Where-Object { $_.Name -eq $project }
        if ($projectItem) {
            $projectItem.Parent = $solutionFolder
        }
    }
}

# Save the solution
$solution.Save()

Write-Host "Solution organization complete!" 