App.Collections.PlayList = Backbone.Collection.extend({
	model: App.Models.Video,
	initialize: function() {
		this.offset = 0;
		this.view = new App.Views.PlayListView({
			el: $("#playlist"),
			collection: this
		});
		PlayerView.collection = this
	},
	search: function() {
		var self = this;
		this.remove($.makeArray(this.models));
		this.playing = null;
		this.offset = 0;
		this.fetch({
			success: function() {
				self.view.refreshViews();
				self.playNext();
			}
		});
	},
	playNext: function() {
		PlayerView.playThis(this.at(this.nextPlayingIndex()));
	},
	playPrev: function() {
		PlayerView.playThis(this.at(this.prevPlayingIndex()));
	},
	currentPlayingIndex: function() {
		return this.models.indexOf(this.playing);
	},
	makeAsPlaying: function(model) {
		this.playing = model;
		this.view.render();
	},
	nextPlayingIndex: function() {
		var index = this.currentPlayingIndex();

		if (index === null || index + 1 === this.length) {
			index = - 1;
		}

		return index + 1;
	},
	prevPlayingIndex: function() {
		var index = this.currentPlayingIndex();

		if (index === null || index - 1 === 0) {
			index = 1;
		}

		return index - 1;
	}
});

