# Typing Park - local preview server
# Serves this folder at http://localhost:8080 (or the next free port).
# Run:  powershell -ExecutionPolicy Bypass -File serve.ps1
# Stop: close the window, or press Ctrl+C.
param([int]$Port = 8080, [switch]$NoBrowser)

$root = (Resolve-Path $PSScriptRoot).Path
$types = @{
  '.html' = 'text/html; charset=utf-8'; '.css' = 'text/css; charset=utf-8'; '.js' = 'text/javascript; charset=utf-8'
  '.png' = 'image/png'; '.jpg' = 'image/jpeg'; '.jpeg' = 'image/jpeg'; '.gif' = 'image/gif'; '.webp' = 'image/webp'
  '.svg' = 'image/svg+xml'; '.ico' = 'image/x-icon'; '.pdf' = 'application/pdf'; '.json' = 'application/json'; '.txt' = 'text/plain; charset=utf-8'
}

$listener = $null
for ($p = $Port; $p -lt $Port + 20; $p++) {
  try {
    $l = New-Object System.Net.HttpListener
    $l.Prefixes.Add("http://localhost:$p/")
    $l.Start(); $listener = $l; $Port = $p; break
  } catch { }
}
if (-not $listener) { Write-Host "Could not find a free port near $Port."; exit 1 }

$url = "http://localhost:$Port/"
Write-Host ""
Write-Host "  Typing Park is running at  $url" -ForegroundColor Green
Write-Host "  Serving folder: $root"
Write-Host "  Close this window (or press Ctrl+C) to stop."
Write-Host ""
if (-not $NoBrowser) { Start-Process $url }

try {
  while ($listener.IsListening) {
    $ctx = $listener.GetContext()
    $req = $ctx.Request; $res = $ctx.Response
    try {
      $rel = [Uri]::UnescapeDataString($req.Url.AbsolutePath).TrimStart('/')
      if ($rel -eq '' -or $rel.EndsWith('/')) { $rel += 'index.html' }
      $full = [IO.Path]::GetFullPath((Join-Path $root $rel))
      if (Test-Path -LiteralPath $full -PathType Container) { $full = Join-Path $full 'index.html' }

      # Only serve files inside this folder
      if (-not $full.StartsWith($root, [StringComparison]::OrdinalIgnoreCase) -or -not (Test-Path -LiteralPath $full -PathType Leaf)) {
        $res.StatusCode = 404
        $body = [Text.Encoding]::UTF8.GetBytes('<h1>404 - Page not found</h1><p><a href="/">Back to Typing Park</a></p>')
        $res.ContentType = 'text/html; charset=utf-8'
      } else {
        $ext = [IO.Path]::GetExtension($full).ToLower()
        $res.ContentType = if ($types.ContainsKey($ext)) { $types[$ext] } else { 'application/octet-stream' }
        $body = [IO.File]::ReadAllBytes($full)
      }
      $res.ContentLength64 = $body.Length
      $res.OutputStream.Write($body, 0, $body.Length)
      Write-Host ("{0:HH:mm:ss}  {1}  {2}" -f (Get-Date), $res.StatusCode, $req.Url.AbsolutePath)
    } catch {
      $res.StatusCode = 500
    } finally {
      $res.OutputStream.Close()
    }
  }
} finally {
  $listener.Stop()
}
