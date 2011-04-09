$(function() {

	$('.datepicker').datepicker().show();

	$("#video_show_name").autocomplete({
		source: "/shows/query",
		minLength: 2
	});

	$("#accordion").accordion({
		autoheight: true,
		event: "mouseover"
	});

	$("#tabs").tabs();

	$(".groups").buttonset();

	$(".best_in_place").best_in_place()

	$("form.button_to").bind("ajax:beforeSend", function() {
		$(this).parents("tr").find(".feed_counter").replaceWith($("<img/>", {
			src: "images/ajax-loader.gif",
			class: "feed_counter"
		}));
	}).bind("ajax:success", function(data, status, xhr) {
		$(this).parents("tr").find(".feed_counter").replaceWith($("<span/>", {
			text: status,
			class: "feed_counter"
		}));
	});
});

