;(function($) {
  /*
    jquery.fbLike.js 
    
    A jQuery wrapper to create a Facebook Like Button
    
    Created by Henning Thies
    http://github.com/henningthies
    
  */

$.fn.fbLike = function(url, options) {
  var opts = $.extend({}, $.fn.fbLike.defaults, options);

  return this.each(function() {
    var $this = $(this);
    
    var _url = "http://www.facebook.com/plugins/like.php?";
      _url += "href="+url;
      _url += "&layout="+opts.layout;
      _url += "&show_faces="+opts.show_faces;
      _url += "&width="+opts.width;
      _url += "&height="+opts.height;
      _url += "&action="+opts.verb;
      _url += "&font="+opts.font;
      _url += "&colorscheme="+opts.color;

    var $iframe = $("<iframe>",{
      scrolling: opts.scrolling,
      frameborder: opts.frameborder,
      allowTransparency: opts.allowTransparency,
      src:_url      
    });
    
    $iframe.ready(function(){
      $this.append($iframe[0]);
    });
    
    
  });

};

// default options
$.fn.fbLike.defaults = {
  scrolling: "no",
  frameborder: 0,
  allowTransparency:true,
  layout: "standard",
  show_faces: true,
  width: 450,
  height: 21,
  verb: "like",
  font: "arial",
  color: "light"  
};

})(jQuery);
