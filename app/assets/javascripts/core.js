$(function() {
	//event if document loads, image load takes time so wait 1 second before repositioning mask
	setTimeout(repositionMask, 1000);
	$( window ).resize(function() {
		repositionMask();
	});
	function repositionMask() {
		var h = $(window).height();
		$('.mask').height(h);
		var margin = (h - $('.mask img').height()) / 2 ;
		$('.mask img').css({margin: margin + 'px auto 0'});
	}
	function showMask() {
		$('.mask').show();
	}
	function hideMask() {
		$('.mask').show();
	}
});
