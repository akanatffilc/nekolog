$(function() {
	//event if document loads, image load takes time so wait 1 second before repositioning mask
	neko.init();
	$( window ).resize(function() {
		neko.repositionMask();
	});
});
var neko = {
	init : function() {
		neko.setTrashUndoDisplay();
		setTimeout(neko.repositionMask(), 1000);
	},
	isMaskShowing : false,
	mask : null,
	setMask : function() {
		neko.mask = $(".mask");
	},
	getMask : function(el) {
		if (neko.mask == null) {
			neko.setMask();
		}
		if (el != null) {
			return $(el, neko.mask);
		}
		return neko.mask;
	},
	showMask : function() {
		neko.getMask().show();
		neko.getMask().css({'z-index' : 50});
		neko.getMask("img").hide();
		neko.getMask("p").hide();
		neko.repositionMask();
	},
	hideMask : function() {
		neko.getMask().hide();
	},
	showLoading : function() {
		neko.getMask().show();
		neko.getMask().css({'z-index' : 200});
		neko.getMask("img").show();
		neko.getMask("p").show();
		neko.repositionMask();
	},
	hideLoading : function() {
		neko.getMask().hide();
	},
	repositionMask : function() {
		var h = $(window).height();
		neko.getMask().height(h);
		var margin = (h - neko.getMask("img").height()) / 2 ;
		neko.getMask("img").css({margin: margin + 'px auto 0'});
	},
	setTrashUndoDisplay : function() {
		if ($(".trash li").length > 0) {
			$(".trash-container .undo").show();
		} else {
			$(".trash-container .undo").hide();
		}
	}
}
var util = {
	centerize : function(el) {
		var w = $(window).width();
		var h = $(window).height();
		var elw = $(el).width();
		var elh = $(el).height();
		var top = ( h - elh ) / 2;
		var left = ( w - elw ) / 2;
		$(el).css({top: top + 'px ', left : left + 'px'});
	}
}
var draggedItem;
var intervalId;	
var isHovering;
var intervalDelay = 10;
var distance;
var tempVal;
var o = { hovering : false };
/* スクロールする時のprototype */
$.fn.extend({
	isScrollTop: function() {
		return this.scrollTop() <= 0;
	},
	isScrollBottom: function() {
		return this.scrollTop() + this.innerHeight() >= this[0].scrollHeight;
	},
	scrollDifference: function(distance) {
		var canScrollDown = distance >= 0 && !this.isScrollBottom();
		var canScrollUp = distance <= 0 && !this.isScrollTop();
		if (canScrollDown || canScrollUp) {
			this.scrollTop(this.scrollTop() + distance);
			return true;
		}
		return false;
	},
});
$(function() {
	var sortables = $('li', '.draggable');
	var sliderContainer = $(".slider-container");
	/* init */
	o.watch("hovering", function(id, oldVal, newVal){
		if (tempVal !== newVal) {
			if (newVal == true) {
				intervalId = setInterval(
					function(){ 
						var canScroll;
						canScroll = sliderContainer.scrollDifference(distance); 
						if (canScroll == false) {
							clearAllInterval();
						}
					}, intervalDelay
				);
			}
		}
	});
	$('.draggable').sortable({
	    connectWith: $('.draggable'),
	    scroll: true, 
	    scrollSensitivity: 100,
	    start: function(event, ui) {
	        draggedItem = ui.item;
	        $(window).mousemove(moved);
	    },
	    stop: function(event, ui) {
	        $(window).unbind("mousemove", moved);
	        clearAllInterval();
	    },
	    receive: function(event, ui) {
	        var sourceList = ui.sender;
	        var targetList = $(this);
	        if (targetList.hasClass("trash")) {
	        	neko.setTrashUndoDisplay();
	        }
	    }
	});
	$(".slider-tab").click(function(){
		$(".slider").animate({
			width:"toggle"
		}, 200);
	});
	$(".viewer-tab").click(function(){
		var v = $(".viewer");
		var vc = $(".viewer-container");
		if (vc.is(':visible')) {
			vc.hide();
			v.width(0);
		} else {
			vc.show();
			v.width(240);
		}
	});
	$(document).on('mouseenter', '.draggable li', function() {
		if (!$(".viewer").hasClass("locked")) {
			var hiddens = ["issueKey","summary","description","priority","status","assignee"];
			var attributePrefix = "viewer-value-";
			$("input[type=hidden]",this).each(function(){
				var className = "." + $(this).attr('viewer-value');
				var val = $(this).val();
				$(".viewer-container " + className).text(val);
				if ($(this).attr('viewer-value') == attributePrefix + "issueKey") {
					$(".viewer-container " + className).parent("a").attr("href", "https://globaldev.backlog.jp/view/" + val);
				}
			});
		}
	});
	$(".trash-container .undo").click(function(){
		var removed = $(".trash li:last-child").remove();
		console.log(removed);
		//TODO add logic to put back whats been popped
		neko.setTrashUndoDisplay();
	});
	$(window).keypress(function( event ) {
		if ( event.which == 108 ) {
			if ($(".viewer").hasClass("locked")){
				$(".viewer").removeClass("locked");
			} else {
				$(".viewer").addClass("locked");
			}
		}
	});
	/* functions */
	function moved(e) {
		var offsetTop = sliderContainer.offset().top;
        var y = e.pageY - offsetTop;
        var h = sliderContainer.height();
        var top = 50;
        var bottom = h - 50;
        $(".up, .down").hide();
        if (y < top && !sliderContainer.isScrollTop()) {
        	$(".up").show();
        	distance = -10;
        	o.hovering = true;
        } else if (y > bottom && !sliderContainer.isScrollBottom()) {
        	$(".down").show();
        	distance = 10;
        	o.hovering = true;
        } else {
        	o.hovering = false;
        }
	};
	function clearAllInterval() {
		for (var i = 1; i < 99999; i++) window.clearInterval(i);
	}
});