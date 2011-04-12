App.Views.Index = Backbone.View.extend({
	render: function() {
		var val = $("#searchBox").val();
		if (this.search) {
			this.search.remove();
		}
		$("#searchBox").val(val);
		this.search = new App.Views.SearchView({
			el: $("#searchBox")
		});
	}
});

