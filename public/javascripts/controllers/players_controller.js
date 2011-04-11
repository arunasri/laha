App.Controllers.PlayersController = Backbone.Controller.extend({
	routes: {
		"": "search",
		":query": "search"
	},
	initialize: function() {
		this.view = new App.Views.Index();
	},
	search: function(query) {
		$("#searchBox").val(query);
		var list = []
		$.each(query.split("#"), function(i, e) {
			$.getJSON("/tags/search", {
				term: e,
                exact: true
			},
			function(response) {
				list << response
			});
		});
		this.view.render();
	}
});

