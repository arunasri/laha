App.Views.Index = Backbone.View.extend({
	initialize: function() {
		this.search = new App.Views.SearchView({
			el: $("#searchBox")
		});
	},
    render: function(){
      this.search.reload();
    }
});

