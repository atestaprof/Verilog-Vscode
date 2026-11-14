$BaseDir = "$PSScriptRoot"
$CategoryName = Split-Path -Path "$BaseDir" -Leaf

Write-Host "================================================================================" -ForegroundColor Cyan
Write-Host " INICIANDO SIMULACION POR LOTES: $CategoryName" -ForegroundColor Cyan
Write-Host " Directorio base: `"$BaseDir`"" -ForegroundColor Cyan
Write-Host "================================================================================" -ForegroundColor Cyan

$Total = 0
$Passed = 0
$Failed = 0

$ProjectDirs = Get-ChildItem -Path "$BaseDir" -Directory

foreach ($Project in $ProjectDirs) {
    $ProjectPath = "$($Project.FullName)"
    $ProjectName = "$($Project.Name)"

    $VerilogFiles = Get-ChildItem -Path "$ProjectPath" -Filter "*.v" -File | ForEach-Object { "$($_.FullName)" }
    if (-not $VerilogFiles -or $VerilogFiles.Count -eq 0) {
        continue
    }

    $Total++
    $BuildDir = "$ProjectPath\build"
    $VvpFile = "$BuildDir\sim.vvp"

    Write-Host ""
    Write-Host "--------------------------------------------------------------------------------" -ForegroundColor Yellow
    Write-Host " [PROYECTO $Total] Simulando: $ProjectName" -ForegroundColor Yellow
    Write-Host "--------------------------------------------------------------------------------" -ForegroundColor Yellow

    if (-not (Test-Path -Path "$BuildDir")) {
        New-Item -ItemType Directory -Force -Path "$BuildDir" | Out-Null
    }

    Write-Host " -> Compilando archivos Verilog con iverilog..." -ForegroundColor Gray
    & iverilog -o "$VvpFile" $VerilogFiles
    if ($LASTEXITCODE -eq 0) {
        Write-Host " [OK] Compilacion exitosa: `"$VvpFile`"" -ForegroundColor Green
    } else {
        Write-Host " [ERROR] Fallo la compilacion en: $ProjectName" -ForegroundColor Red
        $Failed++
        continue
    }

    Write-Host " -> Ejecutando simulacion con vvp (Directorio de trabajo: build/)..." -ForegroundColor Gray
    Push-Location "$BuildDir"
    try {
        & vvp "$VvpFile"
        $SimExitCode = $LASTEXITCODE
    } finally {
        Pop-Location
    }

    if ($SimExitCode -eq 0) {
        $VcdFiles = Get-ChildItem -Path "$BuildDir" -Filter "*.vcd" -File
        if ($VcdFiles -and $VcdFiles.Count -gt 0) {
            Write-Host " [OK] Simulacion exitosa. Archivo(s) VCD generado(s): $($VcdFiles[0].Name)" -ForegroundColor Green
            $Passed++
        } else {
            Write-Host " [ADVERTENCIA] Simulacion finalizo pero no se encontro archivo .vcd en build/" -ForegroundColor Magenta
            $Failed++
        }
    } else {
        Write-Host " [ERROR] Fallo la simulacion en: $ProjectName" -ForegroundColor Red
        $Failed++
    }
}

Write-Host ""
Write-Host "================================================================================" -ForegroundColor Cyan
Write-Host " RESUMEN FINAL ($CategoryName)" -ForegroundColor Cyan
Write-Host " Total: $Total | Exitosos: $Passed | Fallidos: $Failed" -ForegroundColor Cyan
Write-Host "================================================================================" -ForegroundColor Cyan

if ($Failed -gt 0) {
    exit 1
}
