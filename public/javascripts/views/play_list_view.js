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
		var max = this.collection.length,
        start = this.collection.currentPlayingIndex(),
		currentIndex = start + 1;

		this.el.find('a').hide();
		for (var i = 1; i < 5; i++) {
		  this.showVideo(currentIndex);
          currentIndex++
          if ( i > max ){
            currentIndex = 1;
          }
		}

		return this;
	}
});

