$ErrorActionPreference = 'Stop'

$tectonicCommand = Get-Command tectonic -ErrorAction SilentlyContinue
if ($tectonicCommand) {
    $tectonicPath = $tectonicCommand.Source
} else {
    $tectonicPath = Join-Path $env:USERPROFILE '.cache/codex-runtimes/codex-primary-runtime/dependencies/native/tectonic/tectonic.exe'
}
if (-not (Test-Path -LiteralPath $tectonicPath)) {
    throw 'No se encuentra Tectonic. Instálalo o añádelo al PATH.'
}

Push-Location -LiteralPath $PSScriptRoot
try {
    & $tectonicPath --outdir $PSScriptRoot main.tex
    if ($LASTEXITCODE -ne 0) {
        throw "La compilación ha fallado (código $LASTEXITCODE)."
    }
} finally {
    Pop-Location
}
