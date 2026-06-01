<#
  optimize-products.ps1
  Otimiza as fotos de produto para a web: corta para quadrado (center-crop),
  redimensiona para 800x800 e salva JPG comprimido em assets/img/products/<slug>.jpg.
  Os originais pesados são movidos para assets/img/products/_src/ (gitignored).

  Uso (da raiz do projeto):
    .\scripts\optimize-products.ps1

  Sem dependências externas — usa System.Drawing.
#>

Add-Type -AssemblyName System.Drawing

$root    = Split-Path -Parent $PSScriptRoot
$dir     = Join-Path $root 'assets\img\products'
$srcDir  = Join-Path $dir '_src'
$SIZE    = 800
$QUALITY = 82

# Mapa: arquivo original -> slug de saída (= id do produto / id do novo produto)
$map = @{
  'Bombom de brigadeiro.jpg'        = 'tr-brigadeiro'
  'Bombom de coco.jpg'              = 'tr-coco'
  'Bombom de limão.jpg'             = 'tr-limao'
  'Bombom de maracujá.jpg'          = 'tr-maracuja'
  'Bombom de morango com ninho.png' = 'tr-ninho-morango'
  'Buquê de Rosas.jpg'              = 'buque-rosas'
  'Cesta Encantada.jpg'            = 'cesta-encantada'
  'Docinhos Encantados.jpg'        = 'docinhos-encantados'
  'Rosa Encantada.jpg'             = 'rosa-encantada'
}

if (-not (Test-Path $srcDir)) { New-Item -ItemType Directory -Path $srcDir | Out-Null }

# Encoder JPEG com qualidade
$jpegCodec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() |
  Where-Object { $_.MimeType -eq 'image/jpeg' }
$encParams = New-Object System.Drawing.Imaging.EncoderParameters(1)
$encParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter(
  [System.Drawing.Imaging.Encoder]::Quality, [int64]$QUALITY)

foreach ($entry in $map.GetEnumerator()) {
  $inPath = Join-Path $dir $entry.Key
  if (-not (Test-Path $inPath)) { Write-Host "  (pulado, não encontrado) $($entry.Key)" -ForegroundColor DarkYellow; continue }

  $outPath = Join-Path $dir ("{0}.jpg" -f $entry.Value)

  $img = [System.Drawing.Image]::FromFile($inPath)
  try {
    # center-crop para quadrado
    $side = [Math]::Min($img.Width, $img.Height)
    $sx = [int](($img.Width  - $side) / 2)
    $sy = [int](($img.Height - $side) / 2)
    $srcRect = New-Object System.Drawing.Rectangle($sx, $sy, $side, $side)

    $bmp = New-Object System.Drawing.Bitmap($SIZE, $SIZE)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.InterpolationMode  = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.SmoothingMode      = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $g.PixelOffsetMode    = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $dstRect = New-Object System.Drawing.Rectangle(0, 0, $SIZE, $SIZE)
    $g.DrawImage($img, $dstRect, $srcRect, [System.Drawing.GraphicsUnit]::Pixel)
    $g.Dispose()

    $bmp.Save($outPath, $jpegCodec, $encParams)
    $bmp.Dispose()
  }
  finally {
    $img.Dispose()
  }

  $kb = [int]((Get-Item $outPath).Length / 1KB)
  Write-Host ("  OK  {0,-30} -> {1}.jpg  ({2} KB)" -f $entry.Key, $entry.Value, $kb) -ForegroundColor Green

  # move original para _src/
  Move-Item -LiteralPath $inPath -Destination (Join-Path $srcDir $entry.Key) -Force
}

Write-Host "`nConcluído. Originais movidos para assets\img\products\_src\ (gitignored)." -ForegroundColor Cyan
