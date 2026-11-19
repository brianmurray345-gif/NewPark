# Typing Park

The Typing Park website: free, educational typing games for students.

It's a plain static site (HTML + CSS, no WordPress or database). The games themselves are hosted on [itch.io](https://mechdeve.itch.io/); each game page here links out to them.

## Pages

| File | Page |
|---|---|
| `index.html` | Home: game tiles, Our Mission, printables preview |
| `games/*.html` | One portal page per game, linking to itch.io |
| `downloads.html` | Printable Mac and PC keyboards (PDF) |
| `assets/css/style.css` | All styles |
| `assets/images/` | Logo, game banners, printable previews |
| `assets/downloads/` | Printable keyboard PDFs |

## Preview on this computer

Double-click **`Start Website.bat`**. It starts a small local server and opens <http://localhost:8080/>. Close the window to stop it.

Or run it from PowerShell:

```powershell
powershell -ExecutionPolicy Bypass -File serve.ps1
```

## Adding a game

1. Add its banner to `assets/images/game-<name>.png`.
2. Copy one of the files in `games/`, rename it, and change the title, image and itch.io link.
3. Add a tile for it to the game grid in `index.html` and to the "More games" list on the other game pages.
