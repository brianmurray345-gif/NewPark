// Typing Park game player.
// Loads a Unity WebGL game into the page only when the visitor presses Play,
// so the game page itself stays fast. Markup lives in games/*.html:
//   <div class="player-frame" data-game-src="../play/<game>/" data-game-title="...">
//     <button class="player-start">...</button>
//   </div>
//   <button data-player-fullscreen disabled>Fullscreen</button>
(function () {
  document.querySelectorAll('.player').forEach(function (player) {
    var frame = player.querySelector('.player-frame');
    var start = player.querySelector('.player-start');
    var fullscreen = player.querySelector('[data-player-fullscreen]');
    if (!frame || !start) return;

    start.addEventListener('click', function () {
      var iframe = document.createElement('iframe');
      iframe.src = frame.getAttribute('data-game-src');
      iframe.title = (frame.getAttribute('data-game-title') || 'Typing Park') + ' game';
      iframe.allow = 'fullscreen; autoplay';
      iframe.setAttribute('allowfullscreen', '');
      iframe.addEventListener('load', function () { iframe.focus(); });
      frame.replaceChild(iframe, start);

      if (fullscreen) {
        fullscreen.disabled = false;
        fullscreen.addEventListener('click', function () {
          var req = frame.requestFullscreen || frame.webkitRequestFullscreen;
          if (req) req.call(frame);
          iframe.focus();
        });
      }
    });
  });
})();
