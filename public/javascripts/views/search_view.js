App.Views.SearchView = Backbone.View.extend({
	initialize: function() {
		this.collection = new App.Collections.TagsList();
		this.el.tokenInput("/tags/search", {
			queryParam: 'term',
			onAdd: $.proxy(this.addTerm, this),
			onDelete: $.proxy(this.deleteTerm, this)
		});
	},
	addTerm: function(input) {
		this.collection.add(input);
	},
	deleteTerm: function(input) {
		var t = this.collection.find(function(term) {
			return term.id == input.id
		})

		this.collection.remove(t);
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
	}
});

