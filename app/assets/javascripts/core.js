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
		this.getMask().css({'z-index' : 50});
		this.getMask("img").hide();
		this.getMask("p").hide();
		this.repositionMask();
	},
	hideMask : function() {
		this.getMask().hide();
	},
	showLoading : function() {
		this.getMask().show();
		this.getMask().css({'z-index' : 150});
		this.getMask("img").show();
		this.getMask("p").show();
		this.repositionMask();
	},
	hideLoading : function() {
		this.getMask().hide();
	},
	repositionMask : function() {
		var h = $(window).height();
		this.getMask().height(h);
		var margin = (h - this.getMask("img").height()) / 2 ;
		this.getMask("img").css({margin: margin + 'px auto 0'});
	}
}
var util = {
	centerize : function(el) {
		var w = $(window).width();
		var h = $(window).height();
		var elw = $(el).width();
		var elh = $(el).height();
		var top = ( h - elh ) / 2;
		var side = ( w - elw ) / 2;
		$(el).css({margin: top + 'px ' + side + 'px'});
	}
}