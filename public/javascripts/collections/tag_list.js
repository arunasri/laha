App.Collections.TagsList = Backbone.Collection.extend({
	model: App.Models.Tag,
	initialize: function() {
		this.playList = new App.Collections.PlayList();
        this.playList.tagList = this;
		this.bind('add',    this.addTag);
		this.bind('remove', this.removeTag);
        _.bindAll(this, 'addTag', 'updatePlayList', 'removeTag');
	},
	addTag: function(model) {
		this.updatePlayList();
	},
	removeTag: function(model) {
		this.updatePlayList();
	},
	updatePlayList: function(model) {
		this.playList.url = "/?term=" + unescape(this.toSearchParam());
		this.playList.search();
	},
	addIfNotFound: function(tagName) {
		if (tagName && tagName.length > 0 && ! this.present(tagName)) {
			this.add({
				label: tagName
			});
		}
	},
	present: function(tagName) {
		return this.pluck('id').indexOf(tagName) !== - 1;
	},
	toSearchParam: function() {
		return this.pluck('id').join(",");
	}
});

