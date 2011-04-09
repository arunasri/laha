App.Views.PlayListView = Backbone.View.extend({
	refreshViews: function() {
      var self = this;
		$.each(this.el.find('a'), function() {
			$(this).remove();
		});

		this.collection.each(function(video) {
            self.el.append(new App.Views.VideoView({
				model: video
			}).render().el);
		});
	},
	hideVideo: function(index) {
		this.el.find("a:nth-child(" + index + ")").hide();
	},
	showVideo: function(index) {
		this.el.find("a:nth-child(" + index + ")").show();
	},
	render: function() {
		var start = this.collection.currentPlayingIndex(),
		max = start + 3;
		max = (max > this.collection.length) ? this.collection.length: max;
		this.collection.offset = start;

		for (var i = 0; i < this.collection.length; i++) {
			if (i < start || i > max) {
				this.hideVideo(i + 1);
			} else {
				this.showVideo(i + 1);
			}
		}
		return this;
	}
});

