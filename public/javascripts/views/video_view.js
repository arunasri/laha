App.Views.VideoView = Backbone.View.extend({
	tagName: 'a',
	events: {
		"click": "play"
	},
	initialize: function() {
      this.model.view = this;
		_.bindAll(this, 'render', 'play');
	},
	play: function() {
      PlayerView.playThis(this.model);
	},
	render: function() {
		$(this.el).html(JST.video({
			model: this.model
		}));
		return this;
	}
});

