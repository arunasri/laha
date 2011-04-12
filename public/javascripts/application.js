function onYouTubePlayerReady(playerId) {
	var ytplayer = document.getElementById("playing");
	ytplayer.addEventListener("onStateChange", "onPlayerChange");
	ytplayer.addEventListener("onError", "onPlayerError");

	window.PlayerView = new App.Views.PlayerView({
		ytplayer: ytplayer,
		el: $("#playlistWrapper")
	});
	App.init();
}

function onPlayerChange(newstate) {
	window.PlayerView.changeState(newstate);
}

function onPlayerError(error) {
	window.PlayerView.playNext();
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
	currentVideoId = 'USa7JCcgPBA';
	var params = {
		allowScriptAccess: "always"
	};
	var atts = {
		id: "playing",
		allowFullScreen: "true"
	};
	swfobject.embedSWF("http://www.youtube.com/v/" + currentVideoId + "&enablejsapi=1&playerapiid=playing" + "&rel=0&autoplay=0&egm=0&loop=0&fs=1&hd=0&showsearch=0&showinfo=0&iv_load_policy=3&cc_load_policy=1&version=3", "playing", "720", "405", "8", null, null, params, atts);

});

