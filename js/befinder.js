// JavaScript Document

(function( $ ) {
	
	$.fn.findBe = function( listaControls ) {
		
		var input = this.html();
		
		var result = input.replace(/\b(am|is|are|was|were|be|being|been|will|would|i'm|you're|he's|she's|we're|they're|isn't|aren't|weren't|it's)\b/gi, replacer);
		
		function replacer (str, p1, offset, s) {
			return "<strong class=\"bee\">" + p1/*.toUpperCase()*/ + "</strong>";
		}
			
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