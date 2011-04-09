App.Views.PlayerView = Backbone.View.extend({
	initialize: function() {
		this.state = 'pause';
		this.ytplayer = this.options.ytplayer;
		this.el.find("#buttonControl").live('click', $.proxy(this.toggle, this))
		$(document.documentElement).keydown($.proxy(this.move, this));
	},
	move: function(e) {
		if (e.keyCode == 39 || e.keyCode == 40) {
			this.playNext();
		} else if (e.keyCode == 37 || e.keyCode == 38) {
			this.playPrev();
		} else if (e.keyCode == 13) {
			this.toggle();
		}

	},
	toggle: function() {
		if (this.state === 'play') {
			this.pause();
		} else {
			this.play();
		}

		return false;
	},
	changeState: function(state) {
		if (state === 0) {
			this.playNext();
		}
	},
	pause: function() {
		this.el.addClass("playButton");
		this.el.removeClass("pauseButton");
		this.state = 'pause';
		this.ytplayer.pauseVideo();
	},
	play: function() {
		this.el.removeClass("playButton");
		this.el.addClass("pauseButton");
		this.state = 'play';
		this.ytplayer.playVideo();
	},
	playNext: function() {
		this.collection.playNext();
	},
	playPrev: function() {
		this.collection.playPrev();
	},
	playThis: function(model) {
		if (!model) {
			return
		}
		var videoId = model.get('youtube_id');
		this.collection.makeAsPlaying(model);
		this.ytplayer.loadVideoById(videoId);
		this.pause();
		this.el.addClass("play" + this.collection.currentPlayingIndex() - this.collection.offset);
		this.play();
	}
});

