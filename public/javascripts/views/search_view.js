App.Views.SearchView = Backbone.View.extend({
	events: {
		"catcompleteselect": "selected"
	},
	initialize: function() {
		this.collection = new App.Collections.TagsList();
		this.el.catcomplete({
			source: "/tags/search",
			minLength: 2
		});
	},
	reload: function() {
		var self = this;
		this.collection.remove(this.collection.models);
		var html = this.el.val();
		if (html.length === 0) {
			this.collection.updatePlayList();
		}
		else {
			$.each(html.split("#"), function() {
				self.collection.addIfNotFound(this);
			});
			$(this.el).val('');
		}
	},
	selected: function(evt, ui) {
		this.collection.addIfNotFound(ui.item.label);
		this.collection.addIfNotFound(ui.item.category);
		$(this.el).val('');
		return false;
	}
});

