$(function() {
	//event if document loads, image load takes time so wait 1 second before repositioning mask
	setTimeout(neko.repositionMask(), 1000);
	$( window ).resize(function() {
		neko.repositionMask();
	});
});
var neko = {
	isMaskShowing : false,
	mask : null,
	setMask : function() {
		this.mask = $(".mask");
	},
	getMask : function(el) {
		if (this.mask == null) {
			this.setMask();
		}
		if (el != null) {
			return $(el, this.mask);
		}
		return this.mask;
	},
	showMask : function() {
		this.getMask().show();
		this.repositionMask();
	},
	hideMask : function() {
		this.getMask().hide();
	},
	repositionMask : function() {
		var h = $(window).height();
		this.getMask().height(h);
		var margin = (h - this.getMask("img").height()) / 2 ;
		this.getMask("img").css({margin: margin + 'px auto 0'});
	}
}