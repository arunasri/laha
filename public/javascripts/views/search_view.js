App.Views.SearchView = Backbone.View.extend({
	initialize: function() {
		this.collection = new App.Collections.TagsList();
		this.render();
	},
	render: function() {
		var query = this.el.val();
		self = this;

		if (query.length === 0) {
			query = "telugu#song";
		}

		query = query.split("#");

		var deffered = [],
		list = [];
		for (var i = 0; i < query.length; i++) {
			deffered.push($.getJSON("/tags/search", {
				term: query[i],
				exact: true
			}).success(function(data) {
				list.push(data);
                self.addTerm(data);
			}));
		}

		$.when.apply($,deffered).then(function() {
			self.el.tokenInput("/tags/search", {
				prePopulate: list,
				queryParam: 'term',
				theme: "facebook",
				preventDuplicates: true,
				onAdd: $.proxy(self.addTerm, self),
				onDelete: $.proxy(self.deleteTerm, self)
			});
		});
	},
	remove: function() {
		this.collection = new App.Collections.TagsList();
		$(".token-input-list-facebook").remove();
		this.el.remove();
		$("#header").append($("<input/>", {
			type: "text",
			id: "searchBox"
		}));
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

