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
        this.view.render();
	}
});

