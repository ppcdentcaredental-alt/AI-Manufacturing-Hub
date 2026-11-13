$html = [System.IO.File]::ReadAllText('c:\Users\ppc.controllers\Downloads\invitation\index.html')

# Convert frame_006.jpg to base64
$frameBytes = [System.IO.File]::ReadAllBytes('c:\Users\ppc.controllers\Downloads\invitation\frame_006.jpg')
$frameB64 = [Convert]::ToBase64String($frameBytes)
$frameDataUri = "data:image/jpeg;base64," + $frameB64

# CSS to make the card perfectly framed with dark luxury background
$cssToInject = @"
<style>
    html, body {
        overflow: hidden !important;
        margin: 0 !important;
        padding: 0 !important;
        width: 100vw !important;
        height: 100vh !important;
        display: flex !important;
        flex-direction: column !important;
        justify-content: center !important;
        align-items: center !important;
        background: radial-gradient(ellipse at 8% 25%, #391b1c 0, transparent 55%), radial-gradient(ellipse at 100% 0, #263238 0, transparent 50%), #0c1012 !important;
    }
    .wrap {
        width: 1000px !important;
        margin: 0 auto !important;
    }
    .hero-video {
        display: none !important;
    }
    .frame-img {
        display: block !important;
        width: 100% !important;
        height: 100% !important;
        object-fit: cover !important;
    }
</style>
"@

$html = $html.Replace('</head>', $cssToInject + "`n</head>")

# Replace video tag with our frame image, keeping a hidden dummy video so script doesn't throw
$oldVideoStart = $html.IndexOf('<video id="crown-video"')
if ($oldVideoStart -ge 0) {
    $videoEnd = $html.IndexOf('</video>', $oldVideoStart) + 8
    $newImgTag = "<img src='$frameDataUri' class='frame-img' alt='DentCare AI Crown Unveiling' /><video id='crown-video' style='display:none'></video>"
    $html = $html.Substring(0, $oldVideoStart) + $newImgTag + $html.Substring($videoEnd)
}

# Pre-populate countdown values
$html = $html.Replace('<div class="value" id="days">—</div>', '<div class="value" id="days">09</div>')
$html = $html.Replace('<div class="value" id="hours">—</div>', '<div class="value" id="hours">22</div>')
$html = $html.Replace('<div class="value" id="minutes">—</div>', '<div class="value" id="minutes">48</div>')
$html = $html.Replace('<div class="value" id="seconds">—</div>', '<div class="value" id="seconds">55</div>')

[System.IO.File]::WriteAllText('c:\Users\ppc.controllers\Downloads\invitation\render_4k.html', $html)
Write-Output "render_4k.html updated successfully"
