# ====================================================================
# Rosa Encantada - Gera og-image.jpg e twitter-card.jpg
# Renderiza diretamente via System.Drawing (sem dependencias externas)
# Uso (a partir da raiz do projeto): .\scripts\convert-images.ps1
# ====================================================================

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$assets = Join-Path $root 'assets\social'

Add-Type -AssemblyName System.Drawing

# ===== Caracteres Unicode (evita problemas de encoding em scripts PS) =====
$star    = [char]0x2605    # estrela
$arrow   = [char]0x2192    # seta
$ndash   = [char]0x2013    # en dash
$amp     = [char]0x0026    # &
$aGrave  = [char]0x00E0    # à
$aTilde  = [char]0x00E3    # ã
$aCirc   = [char]0x00E2    # â
$eAcute  = [char]0x00E9    # é
$eCirc   = [char]0x00EA    # ê
$iAcute  = [char]0x00ED    # í
$oAcute  = [char]0x00F3    # ó
$oCirc   = [char]0x00F4    # ô
$oTilde  = [char]0x00F5    # õ
$cCedil  = [char]0x00E7    # ç

# ===== Cores da marca =====
$rosaClaro = [System.Drawing.Color]::FromArgb(253, 238, 242)
$rosaSuave = [System.Drawing.Color]::FromArgb(251, 213, 221)
$rosaMedio = [System.Drawing.Color]::FromArgb(247, 198, 211)
$rosaVivo  = [System.Drawing.Color]::FromArgb(214, 51, 108)
$rosaDeep  = [System.Drawing.Color]::FromArgb(177, 38, 78)
$choco     = [System.Drawing.Color]::FromArgb(74, 36, 24)
$chocoSoft = [System.Drawing.Color]::FromArgb(107, 53, 37)
$creme     = [System.Drawing.Color]::FromArgb(255, 250, 247)
$gold      = [System.Drawing.Color]::FromArgb(198, 153, 99)
$white     = [System.Drawing.Color]::White
$transWhite= [System.Drawing.Color]::FromArgb(180, 255, 255, 255)
$transChoco= [System.Drawing.Color]::FromArgb(45, 74, 36, 24)

# ===== Fontes =====
function Get-Font($family, $size, $style = [System.Drawing.FontStyle]::Regular) {
    try {
        return New-Object System.Drawing.Font($family, [single]$size, $style, [System.Drawing.GraphicsUnit]::Pixel)
    } catch {
        return New-Object System.Drawing.Font('Georgia', [single]$size, $style, [System.Drawing.GraphicsUnit]::Pixel)
    }
}

# ===== Helpers =====
function Set-Quality($g) {
    $g.SmoothingMode      = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $g.InterpolationMode  = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.PixelOffsetMode    = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $g.TextRenderingHint  = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
    $g.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality
}

function Draw-LinearGradient($g, $rect, $colorStart, $colorEnd, $angle = 90) {
    $brush = New-Object System.Drawing.Drawing2D.LinearGradientBrush($rect, $colorStart, $colorEnd, [single]$angle)
    $g.FillRectangle($brush, $rect)
    $brush.Dispose()
}

function Draw-RadialBlob($g, $cx, $cy, $r, $color, $opacity = 1.0) {
    $alpha = [int]([math]::Min(255, [math]::Max(0, $opacity * 255)))
    $c = [System.Drawing.Color]::FromArgb($alpha, $color.R, $color.G, $color.B)
    $path = New-Object System.Drawing.Drawing2D.GraphicsPath
    $path.AddEllipse(($cx - $r), ($cy - $r), ($r * 2), ($r * 2))
    $brush = New-Object System.Drawing.Drawing2D.PathGradientBrush($path)
    $brush.CenterColor = $c
    $brush.SurroundColors = @([System.Drawing.Color]::FromArgb(0, $color.R, $color.G, $color.B))
    $g.FillPath($brush, $path)
    $brush.Dispose()
    $path.Dispose()
}

function Draw-RoundedRect($g, $x, $y, $w, $h, $radius, $brush) {
    $path = New-Object System.Drawing.Drawing2D.GraphicsPath
    $d = $radius * 2
    $path.AddArc($x, $y, $d, $d, 180, 90)
    $path.AddArc(($x + $w - $d), $y, $d, $d, 270, 90)
    $path.AddArc(($x + $w - $d), ($y + $h - $d), $d, $d, 0, 90)
    $path.AddArc($x, ($y + $h - $d), $d, $d, 90, 90)
    $path.CloseFigure()
    $g.FillPath($brush, $path)
    $path.Dispose()
}

function Draw-RoundedRectStroke($g, $x, $y, $w, $h, $radius, $pen) {
    $path = New-Object System.Drawing.Drawing2D.GraphicsPath
    $d = $radius * 2
    $path.AddArc($x, $y, $d, $d, 180, 90)
    $path.AddArc(($x + $w - $d), $y, $d, $d, 270, 90)
    $path.AddArc(($x + $w - $d), ($y + $h - $d), $d, $d, 0, 90)
    $path.AddArc($x, ($y + $h - $d), $d, $d, 90, 90)
    $path.CloseFigure()
    $g.DrawPath($pen, $path)
    $path.Dispose()
}

function Draw-PillGradient($g, $x, $y, $w, $h, $colorStart, $colorEnd) {
    $radius = [math]::Min($w, $h) / 2
    $rect = New-Object System.Drawing.RectangleF([single]$x, [single]$y, [single]$w, [single]$h)
    $brush = New-Object System.Drawing.Drawing2D.LinearGradientBrush($rect, $colorStart, $colorEnd, [single]135)
    Draw-RoundedRect $g $x $y $w $h $radius $brush
    $brush.Dispose()
}

function Draw-Text($g, $text, $font, $color, $x, $y, $align = 'left') {
    $brush = New-Object System.Drawing.SolidBrush($color)
    $size = $g.MeasureString($text, $font)
    $px = $x
    if ($align -eq 'center') { $px = $x - ($size.Width / 2) }
    if ($align -eq 'right')  { $px = $x - $size.Width }
    $g.DrawString($text, $font, $brush, [single]$px, [single]$y)
    $brush.Dispose()
}

function Draw-Truffle($g, $cx, $cy, $r) {
    # Frame circular branco
    $frameBrush1 = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(110, 255, 255, 255))
    $g.FillEllipse($frameBrush1, ($cx - $r - 25), ($cy - $r - 25), ($r * 2 + 50), ($r * 2 + 50))
    $frameBrush1.Dispose()
    $frameBrush2 = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(190, 255, 255, 255))
    $g.FillEllipse($frameBrush2, ($cx - $r), ($cy - $r), ($r * 2), ($r * 2))
    $frameBrush2.Dispose()

    # Sombra base
    $shadow = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(45, 74, 36, 24))
    $g.FillEllipse($shadow, ($cx - 80), ($cy + 60), 160, 24)
    $shadow.Dispose()

    # Trufa principal
    $tBrush = New-Object System.Drawing.SolidBrush($choco)
    $g.FillEllipse($tBrush, ($cx - 75), ($cy - 75), 150, 150)
    $tBrush.Dispose()

    # Highlight 1 (chocolate mais claro)
    $h1 = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(150, 107, 53, 37))
    $g.FillEllipse($h1, ($cx - 50), ($cy - 50), 50, 50)
    $h1.Dispose()

    # Highlight branco (brilho)
    $h2 = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(110, 255, 255, 255))
    $g.FillEllipse($h2, ($cx - 38), ($cy - 52), 22, 22)
    $h2.Dispose()

    # Detalhe rosa por cima (cereja)
    $cherry = New-Object System.Drawing.SolidBrush($rosaVivo)
    $g.FillEllipse($cherry, ($cx + 18), ($cy - 65), 32, 32)
    $cherry.Dispose()
    $cherryShine = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(140, 255, 255, 255))
    $g.FillEllipse($cherryShine, ($cx + 28), ($cy - 60), 10, 10)
    $cherryShine.Dispose()

    # Polvilhos (sprinkles)
    $sp = New-Object System.Drawing.SolidBrush($rosaSuave)
    $sprinkles = @(@(-40, 20), @(20, 35), @(50, 10), @(-15, 50), @(0, 5), @(35, -25))
    foreach ($pt in $sprinkles) {
        $g.FillEllipse($sp, ($cx + $pt[0] - 3), ($cy + $pt[1] - 3), 6, 6)
    }
    $sp.Dispose()
}

function Draw-Seal($g, $cx, $cy, $r, $rating, $label) {
    $sealBrush = New-Object System.Drawing.SolidBrush($choco)
    $g.FillEllipse($sealBrush, ($cx - $r), ($cy - $r), ($r * 2), ($r * 2))
    $sealBrush.Dispose()
    $borderPen = New-Object System.Drawing.Pen($creme, 4)
    $g.DrawEllipse($borderPen, ($cx - $r + 2), ($cy - $r + 2), ($r * 2 - 4), ($r * 2 - 4))
    $borderPen.Dispose()

    $fontStar = Get-Font 'Georgia' 26 ([System.Drawing.FontStyle]::Bold)
    $fontLbl  = Get-Font 'Segoe UI' 11
    Draw-Text $g $rating $fontStar $white $cx ($cy - 22) 'center'
    Draw-Text $g $label  $fontLbl  $rosaSuave $cx ($cy + 8) 'center'
    $fontStar.Dispose(); $fontLbl.Dispose()
}

function Draw-Brand($g, $x, $y) {
    # Logo redondo
    $logoBrush = New-Object System.Drawing.SolidBrush($rosaVivo)
    $g.FillEllipse($logoBrush, $x, $y, 44, 44)
    $logoBrush.Dispose()
    $fontR = Get-Font 'Georgia' 22 ([System.Drawing.FontStyle]::Bold)
    Draw-Text $g 'R' $fontR $white ($x + 22) ($y + 6) 'center'
    $fontR.Dispose()

    $fontName = Get-Font 'Georgia' 20 ([System.Drawing.FontStyle]::Bold)
    $fontTag  = Get-Font 'Segoe Script' 18 ([System.Drawing.FontStyle]::Italic)
    Draw-Text $g 'Rosa Encantada' $fontName $choco ($x + 56) ($y - 2)
    Draw-Text $g 'by Lorraine'    $fontTag  $rosaVivo ($x + 56) ($y + 22)
    $fontName.Dispose(); $fontTag.Dispose()
}

# ===== Geracao do og-image (1200 x 630) =====
function New-OGImage($outPath) {
    $w = 1200; $h = 630
    $bmp = New-Object System.Drawing.Bitmap($w, $h)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    Set-Quality $g

    # Fundo gradiente
    $rect = New-Object System.Drawing.Rectangle(0, 0, $w, $h)
    Draw-LinearGradient $g $rect $rosaClaro $rosaMedio 135

    # Blobs decorativos
    Draw-RadialBlob $g 120 120 220 $rosaMedio 0.55
    Draw-RadialBlob $g 1080 540 280 $rosaSuave 0.65
    Draw-RadialBlob $g 900 120 160 ([System.Drawing.Color]::FromArgb(255, 233, 194)) 0.45
    Draw-RadialBlob $g 900 315 380 $white 0.55

    # Borda decorativa
    $borderPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(150, 255, 255, 255), 2)
    Draw-RoundedRectStroke $g 40 40 1120 550 32 $borderPen
    $borderPen.Dispose()

    # ----- Conteudo lado esquerdo -----
    $cx = 90

    # Eyebrow line + texto
    $linePen = New-Object System.Drawing.Pen($rosaVivo, 2.5)
    $g.DrawLine($linePen, [single]$cx, [single]150, [single]($cx + 40), [single]150)
    $linePen.Dispose()
    $fEyebrow = Get-Font 'Segoe Script' 28 ([System.Drawing.FontStyle]::Italic)
    Draw-Text $g "Trufas $amp bombons artesanais" $fEyebrow $rosaVivo ($cx + 56) 132
    $fEyebrow.Dispose()

    # Titulo
    $fTitle = Get-Font 'Georgia' 78 ([System.Drawing.FontStyle]::Bold)
    Draw-Text $g 'Pequenos' $fTitle $choco $cx 180
    $fTitle.Dispose()

    $fScript = Get-Font 'Segoe Script' 96 ([System.Drawing.FontStyle]::Italic)
    Draw-Text $g 'encantos' $fScript $rosaVivo $cx 270
    $fScript.Dispose()

    $fTitle2 = Get-Font 'Georgia' 78 ([System.Drawing.FontStyle]::Bold)
    Draw-Text $g 'de chocolate.' $fTitle2 $choco $cx 380
    $fTitle2.Dispose()

    # Subtitulo
    $fSub = Get-Font 'Segoe UI' 22
    Draw-Text $g "Feitos $($aGrave) m$($aTilde)o, com chocolate belga e capricho" $fSub $chocoSoft $cx 478
    Draw-Text $g 'em cada detalhe.' $fSub $chocoSoft $cx 508
    $fSub.Dispose()

    # CTA pill
    Draw-PillGradient $g $cx 545 360 58 $rosaVivo $rosaDeep
    $fCta = Get-Font 'Segoe UI' 18 ([System.Drawing.FontStyle]::Regular)
    Draw-Text $g "Conhe$($cCedil)a os sabores  $arrow" $fCta $white ($cx + 180) 561 'center'
    $fCta.Dispose()

    # ----- Lado direito: trufa decorativa -----
    Draw-Truffle $g 1040 315 95

    # ----- Selo 5,0 -----
    Draw-Seal $g 1010 90 60 "$star 5,0" 'CLIENTES'

    $g.Dispose()

    Save-Jpg $bmp $outPath 90
    $bmp.Dispose()
}

# ===== Geracao do twitter-card (1200 x 600) =====
function New-TwitterCard($outPath) {
    $w = 1200; $h = 600
    $bmp = New-Object System.Drawing.Bitmap($w, $h)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    Set-Quality $g

    # Fundo gradiente
    $rect = New-Object System.Drawing.Rectangle(0, 0, $w, $h)
    Draw-LinearGradient $g $rect $rosaClaro $rosaMedio 135

    # Blobs
    Draw-RadialBlob $g 100 540 240 $rosaSuave 0.65
    Draw-RadialBlob $g 1100 80 200 $rosaMedio 0.55
    Draw-RadialBlob $g 850 500 180 ([System.Drawing.Color]::FromArgb(255, 233, 194)) 0.45
    Draw-RadialBlob $g 900 300 340 $white 0.5

    # Borda
    $borderPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(140, 255, 255, 255), 2)
    Draw-RoundedRectStroke $g 40 40 1120 520 32 $borderPen
    $borderPen.Dispose()

    $cx = 90

    # Eyebrow
    $linePen = New-Object System.Drawing.Pen($rosaVivo, 2.5)
    $g.DrawLine($linePen, [single]$cx, [single]140, [single]($cx + 40), [single]140)
    $linePen.Dispose()
    $fEyebrow = Get-Font 'Segoe Script' 28 ([System.Drawing.FontStyle]::Italic)
    Draw-Text $g 'Trufas artesanais' $fEyebrow $rosaVivo ($cx + 56) 122
    $fEyebrow.Dispose()

    # Titulo
    $fTitle = Get-Font 'Georgia' 70 ([System.Drawing.FontStyle]::Bold)
    Draw-Text $g "Doce $eAcute detalhe." $fTitle $choco $cx 165
    $fTitle.Dispose()

    $fScript = Get-Font 'Segoe Script' 84 ([System.Drawing.FontStyle]::Italic)
    Draw-Text $g "Detalhe $eAcute afeto." $fScript $rosaVivo $cx 250
    $fScript.Dispose()

    # Subtitulo
    $fSub = Get-Font 'Segoe UI' 22
    Draw-Text $g "Trufas e bombons feitos $aGrave m$($aTilde)o com chocolate belga." $fSub $chocoSoft $cx 360
    Draw-Text $g 'Pequenos encantos para grandes momentos.' $fSub $chocoSoft $cx 392
    $fSub.Dispose()

    # Chips
    $chipFont = Get-Font 'Segoe UI' 16
    $chips = @('100% artesanal', 'Chocolate belga', 'Caixa para presente')
    $chipX = $cx
    $chipY = 440
    foreach ($chip in $chips) {
        $size = $g.MeasureString($chip, $chipFont)
        $cw = [int]$size.Width + 60
        $ch = 38
        $bg = New-Object System.Drawing.SolidBrush($white)
        Draw-RoundedRect $g $chipX $chipY $cw $ch 19 $bg
        $bg.Dispose()
        $stroke = New-Object System.Drawing.Pen($rosaSuave, 1)
        Draw-RoundedRectStroke $g $chipX $chipY $cw $ch 19 $stroke
        $stroke.Dispose()
        $dot = New-Object System.Drawing.SolidBrush($rosaVivo)
        $g.FillEllipse($dot, ($chipX + 16), ($chipY + 17), 6, 6)
        $dot.Dispose()
        Draw-Text $g $chip $chipFont $chocoSoft ($chipX + 32) ($chipY + 9)
        $chipX += $cw + 12
    }
    $chipFont.Dispose()

    # CTA
    Draw-PillGradient $g $cx 500 340 56 $rosaVivo $rosaDeep
    $fCta = Get-Font 'Segoe UI' 18
    Draw-Text $g "Pe$($cCedil)a pelo WhatsApp  $arrow" $fCta $white ($cx + 170) 515 'center'
    $fCta.Dispose()

    # Trufa decorativa
    Draw-Truffle $g 920 280 80

    $g.Dispose()
    Save-Jpg $bmp $outPath 90
    $bmp.Dispose()
}

function Save-Jpg($bmp, $path, $quality) {
    $encoder = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq 'image/jpeg' }
    $params  = New-Object System.Drawing.Imaging.EncoderParameters(1)
    $params.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, [long]$quality)
    $bmp.Save($path, $encoder, $params)
}

# ===== Execucao =====
Write-Host ""
Write-Host "Rosa Encantada - gerando imagens sociais..." -ForegroundColor Magenta
Write-Host ""

$ogPath  = Join-Path $assets 'og-image.jpg'
$twPath  = Join-Path $assets 'twitter-card.jpg'

New-OGImage $ogPath
$ogSize = [math]::Round((Get-Item $ogPath).Length / 1KB, 1)
Write-Host ("  OK  og-image.jpg     1200x630  $ogSize KB") -ForegroundColor Green

New-TwitterCard $twPath
$twSize = [math]::Round((Get-Item $twPath).Length / 1KB, 1)
Write-Host ("  OK  twitter-card.jpg 1200x600  $twSize KB") -ForegroundColor Green

Write-Host ""
Write-Host "Concluido. Imagens salvas em assets/." -ForegroundColor Magenta
Write-Host ""
