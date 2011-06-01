// JavaScript Document

(function( $ ) {
	
	$.fn.findBe = function( listaControls ) {
		
		var input = this.html();
		
		var result = input.replace(/(\bam\b|\bis\b|\bare\b|\bwas\b|\bwere\b|\bbe\b|\bbeing\b|\bbeen\b)/gi, replacer);
		
		function replacer (str, p1, offset, s) {
			return "<strong class=\"bee\">" + p1/*.toUpperCase()*/ + "</strong>";
		}
		
		/*if ( $("#result div.wysiwyg").length != 0 )
			//$("destination").val(result).wysiwyg("destroy").wysiwyg({ controls : listaControls });
			alert("true!");
		else 
			//$("#destination").val(result).wysiwyg({ controls : listaControls });
			alert("false!");*/
			
		$("#destination").val(result).wysiwyg({ controls : listaControls });
		$(".loading").remove();
	}

	
})( jQuery );

$(document).ready(function(){
		
	/* Hide everything but the basic box. Thanks, Kevin Baugh! */
	var listaControls = {
		 bold: { visible : false },
		 italic: { visible : false },
		 strikeThrough: { visible : false },
		 underline: { visible : false },
		 justifyLeft: { visible : false },
		 justifyCenter: { visible : false },
		 justifyRight: { visible : false },
		 justifyFull: { visible : false },
		 indent: { visible : false },
		 outdent: { visible : false },
		 subscript: { visible : false },
		 superscript: { visible : false },
		 undo: { visible : false },
		 redo: { visible : false },
		 insertOrderedList: { visible : false },
		 insertUnorderedList: { visible : false },
		 insertHorizontalRule: { visible : false },
		 createLink: { visible : false },
		 insertImage: { visible : false },
		 h1: { visible : false },
		 h2: { visible : false },
		 h3: { visible : false },
		 paragraph: { visible : false },
		 cut: { visible : false },
		 copy: { visible : false },
		 paste: { visible : false },
		 increaseFontSize: { visible : false },
		 decreaseFontSize: { visible : false },
		 html: { visible : false },
		 removeFormat: { visible : false },
		 insertTable: { visible : false },
		 code: { visible : false }
    };
	
	/*** INITIALIZE ***/
	$("#source").wysiwyg({ controls : listaControls });
	$("#input, #result").width($("div.wysiwyg").width());
	
	
	/*** LISTENERS ***/	
	$(".submit").mousedown(function(){
		$(this).css("background-position", "0 -32px");
		$("<div class='loading' />").insertAfter("#result h2");
		$("#destination").wysiwyg("destroy");
	});
	$(".submit").mouseup(function(){
		$(this).css("background-position", "0 0");
	});
	$(".submit").click(function(e){			
		$("div.wysiwyg iframe").contents().find('body.wysiwyg').findBe( listaControls );				
		/*$("div.wysiwyg iframe").contents().find(".bee").css({
			//"border-radius" : "5px",
			//"-moz-border-radius" : "5px",
			//"-webkit-border-radius" : "5px",
			//"background-color" : "#F9DB77"
			
			"border-radius" : "3px",
			"background" : "-webkit-gradient(linear, left top, left bottom, from(#F7EC92), to(#FFBE4A)) ",
			"padding" : "2px",
			"margin" : "-2px",
			"box-shadow" : "rgba(0, 0, 0, .25) 0px 1px 0px"

		});	*/
		e.preventDefault();
	});
	
	
	$(".reset").mousedown(function(){
		$(this).css("background-position", "0 -23px");
	});
	$(".reset").mouseup(function(){
		$(this).css("background-position", "0 0");
	});
	$(".reset").click(function(e){
		$("#source").wysiwyg("clear");
		e.preventDefault();
	});
	
	
	
	
	
	
});