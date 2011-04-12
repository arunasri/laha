function onYouTubePlayerReady(playerId) {
	var ytplayer = document.getElementById("playing");
	ytplayer.addEventListener("onStateChange", "onPlayerChange");

	window.PlayerView = new App.Views.PlayerView({
		ytplayer: ytplayer,
		el: $("#playlistWrapper")
	});
	App.init();
}

function onPlayerChange(newstate) {
  window.PlayerView.changeState(newstate);
}

var App = {
	Views: {},
	Models: {},
	Controllers: {},
	Collections: {},
	init: function() {
		new App.Controllers.PlayersController();
		Backbone.history.start()
	}
};

jQuery(function($) {
	swfobject.embedSWF("http://www.youtube.com/v/USa7JCcgPBA&enablejsapi=1&fs=1", "playing", "720", "405", "8", null, null, {
		allowScriptAccess: "always"
	},
	{
		id: "playing"
	});
});
