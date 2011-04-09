App.Views.TagView = Backbone.View.extend({
	tagName: 'small',
	events: {
		'click .ui-icon-circle-close': 'clear'
	},
	initialize: function() {
		this.model.view = this;
		_.bindAll(this, 'render', 'remove');
	},
	render: function() {
		$(this.el).html(JST.search_term({
			model: this.model
		}));
		return this;
	},
    clear: function(){
      this.collection.remove(this.model);
    }
});

App.Views.ClearView = Backbone.View.extend({
	tagName: 'small',
	events: {
		'click .ui-icon-arrowreturnthick-1-w': 'remove',
		'click .cancel': 'remove'
	},
	initialize: function() {
		_.bindAll(this, 'render');
	},
	render: function() {
		$(this.el).html(JST.search_clear({}));
		return this;
	},
	remove: function() {
		this.collection.remove($.makeArray(this.collection.models));
	}
});

App.Views.TagContainerView = Backbone.View.extend({
	addTag: function(tag) {
		new App.Views.TagView({
			model: tag,
			collection: this.collection
		});

		if (this.collection.length === 1) {
			this.clearSearch = new App.Views.ClearView({
				collection: this.collection
			});
			this.el.append(this.clearSearch.render().el);
		}
		$(tag.view.render().el).insertBefore($(this.clearSearch.el));
	},
	removeTag: function(tag) {
		tag.view.remove();
		if (this.collection.length === 0) {
			$(this.clearSearch.el).remove();
		}
	}
});

