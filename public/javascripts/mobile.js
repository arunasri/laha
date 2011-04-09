$(function() {
	$('div').live('pageshow', function(page, nextPage) {
		$(".videobox").each(function(i, video) {
			var $video = $(video);
			jwplayer($video.attr('id')).setup({
				skin: "/images/glow.zip",
				//plugins: 'like-1',
				//autostart: true,
				flashplayer: "/images/player.swf",
				file: "http://www.youtube.com/watch?v=" + $video.attr('link'),
				type: 'youtube',
				height: $video.attr("height"),
				width: $video.attr("width")
			});
		});
	});
});

