Namespace('BeFinder').Creator = do ->
	_widget  = null # holds widget data
	_qset    = null # keeps tack of the current qset
	_title   = null # holds on to this instance's title
	_version = null # holds the qset version, allows you to change your widget to support old versions of your own code
	
	# variables to contain templates for various page elements
	_qTemplate = null
	_qWindowTemplate = null
	_aTemplate = null
	# numQs = 0

	# reference for question answer lists
	_letters = ['A','B','C','D']

	# strings containing tutorial texts, boolean for tutorial mode
	_tutorial_help = false
	_openQ = null
	_openQWindow= null
	# creating the tutorial from HTML classes		
	tutorial1 = $('.tutorial.step1')
	tutorial2 = $('.tutorial.step2')

	initNewWidget = (widget, baseUrl) ->
		_tutorial_help = true
		_buildDisplay 'New Widget Title', widget

	initExistingWidget = (title, widget, qset, version, baseUrl) -> _buildDisplay title, widget, qset, version

	onSaveClicked = (mode = 'save') ->
		if _buildSaveData()
			Materia.CreatorCore.save _title, _qset
		else
			Materia.CreatorCore.cancelSave 'Widget not ready to save.'

	onSaveComplete = (title, widget, qset, version) -> true

	onQuestionImportComplete = (questions) ->
		for question in questions
			_addQuestion question

	# This basic widget does not support media
	onMediaImportComplete = (media) -> null

	_buildDisplay = (title = 'Default test Title', widget, qset, version) ->
		_version = version
		_qset    = qset
		_widget  = widget
		_title   = title

		$('#title').val _title

		# fill the template objects
		unless _qTemplate
			_qTemplate = $('.template.question')
			$('.template.question').remove()
			_qTemplate.removeClass('template')
		unless _qWindowTemplate
			_qWindowTemplate = $('.template.question_window')
			$('.template.question_window').remove()
			_qWindowTemplate.removeClass('template')
		unless _aTemplate
			_aTemplate = $('.template.answer')
			$('.template.answer').remove()
			_aTemplate.removeClass('template')

		#when Add question is clicked.
		$('.add_question_box').click ->
			unless $(this).hasClass('disabled')
				_addQuestion()

		# Start tutorial.
		if _tutorial_help
			$('body').append tutorial1
			tutorial1.addClass('fadeIn')

		# Some set of questions already exists. 
		if _qset?
			questions = _qset.items
			_addQuestion question for question in questions

	_buildSaveData = ->
		okToSave = false

		# Create new qset object if we don't already have one, set default values regardless.
		unless _qset?
			_qset = {}
		_qset.options = {}
		_qset.assets = []
		_qset.rand = false
		_qset.options.randomize = $('#randomize').prop 'checked'
		_qset.name = 'test'
		# update our values
		_title = $('#title').val()
		okToSave = true if _title? && _title != ''

		questions = $('.question')
		qList = _loadingQuestionsforSave questions
		qList.assets = []
		qList.options = {cid: 0}

		_qset.items = qList.items
		okToSave

	# get each question's data from the appropriate page elements
	_loadingQuestionsforSave = (allQuestions) ->
		# allQuestions = $('.question')
		questionList = {name: '', items: []}
		items = []
		for q in allQuestions
			question = $.data q
			questionList.items.push question

		questionList.name = 'Questions'
		questionList

	_addQuestion = (question=null) ->
		# Check the number fo questions in the question container.
		numquestions = $('.question').length
		
		if numquestions is 3
			Materia.CreatorCore.alert '3 Question Limit', 'For this Widget, you may create up to 3 questions'
		else
			# Disable Add new question button while question editor is open.
			# $('.add_question_box').addClass('disabled')

			# Remove step 1 and add step 2 tutorial
			if _tutorial_help and tutorial1.length > 0
				tutorial1.addClass('out')
				$('body').append tutorial2
				tutorial2.addClass('fadeIn')

			# create a new question element and default its pertinent data
			newQ = _qTemplate.clone()

			$.data(newQ[0], 'questions', [{text: ''}])
			$.data(newQ[0], 'answers', [])
			$.data(newQ[0], 'assets', [])
			$.data(newQ[0], 'id', '')
			$.data(newQ[0], 'type', 'MC')

			$('.qBox_container').append newQ
			newQ.addClass('show')

			# When a Question button is clicked, change to that question.
			newQ.click () ->
				_changeQuestion this unless $(this).hasClass('dim') or $(this).hasClass('selected')

			# if the question already exists
			if question?
				fit_text = question.questions[0].text
				if fit_text.length > 20
					fit_text = fit_text.substring(0, 57) + '...'
				newQ.find('.question_text').text fit_text
				$.data(newQ[0], 'questions', [{text: question.questions[0].text}])
				$.data(newQ[0], 'answers', question.answers)
			else
				$(newQ).click()

	_validateAndStoreAnswers = (q, original_question, qWindow) ->
		# Check to make sure the question is filled in.
		if $('#question_text').val() is ''
			$(q).remove()
			Materia.CreatorCore.alert 'Blank Question', 'You can not have a blank question!'
			return

		valid_answers = false
		new_answers = []
		changed = 0
		answer_elements = $('.answer')

		# Check all answers and make sure we can save.
		for na in answer_elements
			original = $.data na, 'original'

			text = $(na).find('.answer_text').val()
			if text is ''
				$(q).remove()
				Materia.CreatorCore.alert 'Blank Answer', 'You can not have a blank answer!'
				return
			
			value = parseInt($(na).find('.answer_value').val())
			valid_answers = true if value is 100

			t_comp = text == original.text
			v_comp = parseInt(value) == parseInt(original.value)

			# Check to see if text has changed.
			if original.id is '' or original_question isnt qWindow.find('#question_text').val()
				changed++
			else
				changed++ unless t_comp and v_comp
			
			new_answers.push({
				'id': original.id
				'text': text,
				'value': value,
				'options':{
					'letter': $(na).find('.letter').text
				}
			})

		# Check to make sure at least one answer is valid.
		unless valid_answers
			Materia.CreatorCore.alert 'No Correct Answer', 'You must have at least one correct answer worth 100% credit!'
			return

		$.data(q, 'questions', [{text:$('#question_text').val()}])
		if changed > 0
			$.data(q, 'answers', new_answers)
			fit_text = $('#question_text').val()
			if fit_text.length > 60
				fit_text = fit_text.substring(0, 57) + '...'
			$(q).find('.question_text').text fit_text

	# Open the question edit window, populate it with info based on the clicked question's data.
	_changeQuestion = (q) ->
		$('.add_question_box').addClass('disabled')
		$(q).addClass 'selected'
		qWindow = $(_qWindowTemplate).clone()

		qWindow.find('#question_text').val $.data(q).questions[0].text
		answers = $.data(q, 'answers')

		# If there is already a window open, close it, then open new question.
		if _openQWindow
			$(_openQWindow).remove()
			$(_openQ).removeClass 'selected'
		
		_openQ = q
		_openQWindow = qWindow
		
		# Store the original question data so we can check it for any changes later.
		original_question = $.data(_openQ).questions[0].text

		_addAnswer $(qWindow).find('#add_answer'), a for a in answers

		qWindow.find('#delete').click () ->
			# Remove step 2.
			if tutorial2.length > 0
				tutorial2.addClass('out')

			# Remove the question no matter what.
			$(qWindow).remove()
			$(q).remove()
			_openQWindow = null
			_openQ = null

			# Enable Add Question button now that the qwindow is removed.
			$('.add_question_box').removeClass('disabled')

		qWindow.find('#cancel').click () ->
			# Remove question with no answers, otherwise just close window.
			$(q).remove() if $.data(q, 'answers').length is 0

			# Remove step 2.
			if tutorial2.length > 0
				tutorial2.addClass('out')
				
			qWindow.remove()
			_openQWindow = null
			_openQ = null
			# Remove selected since canceling
			$('.selected').removeClass('selected')

			# Enable Add Question button now that the qwindow is removed.
			$('.add_question_box').removeClass('disabled')

		# Validate info, then save changes.
		qWindow.find('#save').click () ->
			# Remove step 2.
			if tutorial2.length > 0
				tutorial2.addClass('out')

			_validateAndStoreAnswers q, original_question, qWindow

			$(qWindow).removeClass('show')
			$(qWindow).remove()

			# Remove selected since canceling
			$('.selected').removeClass('selected')
			_openQ = null
			
			# Enable Add Question button now that the qwindow is removed
			$('.add_question_box').removeClass('disabled')

		qWindow.find('#add_answer').click () ->
			if $('.answer').length is 4
				Materia.CreatorCore.alert 'Maximum Answers', 'You already have the maximum number of answers for this question!'
			else
				_addAnswer this
				_resetLetters()
		qWindow.find('#add_answer').keyup () ->
			$(this).click() if event.which is 13 or event.which is 32

		$('body').append qWindow
		qWindow.addClass('show')
		qWindow.find('#question_text').focus()
		_resetLetters()

	_addAnswer = (loc, a=null) ->
		answer = $(_aTemplate).clone()
		original = {id: '', text: '', value: 0}

		answer.find('.answer_remove').click () ->
			answer.remove()
			$('.add_answer').show()
			_resetLetters()

		answer.find('.answer_correct').click () ->
			if $(this).prop 'checked'
				answer.find('.answer_value').val '100%'
			else
				answer.find('.answer_value').val '0%'

		# constrain all typed values to 0 or 100, then add a % to the end
		answer.find('.answer_value').blur () ->
			value = parseInt $(this).val()
			if isNaN value
				$(this).val '0%'
			else if value > 100
				$(this).val '100%'
			else
				$(this).val value+'%'
		# spoof an unfocus, then reclick when pressing enter
		answer.find('.answer_value').keyup () ->
			if event.which is 13
				this.blur()
				this.focus()

		if a?
			original.id = a.id
			$(answer).find('.answer_text').val a.text
			original.text = a.text
			value = a.value
			original.value = a.value
			if parseInt(value) > 0
				$(answer).find('.answer_value').val value+'%'
				$(answer).find('.answer_correct').prop 'checked', true

		$.data(answer[0], 'original', original)
		$(loc).before answer
		answer.find('.answer_text').focus()

	# change each answer's letter based on how many there are
	_resetLetters = ->
		num_answers = $('.answer').length
		if num_answers is 4
			$('#add_answer').hide()

		answers = $('.answer')
		for answer, i in answers
			$(answer).find('.letter').text _letters[i]

	#public
	initNewWidget: initNewWidget
	initExistingWidget: initExistingWidget
	onSaveClicked:onSaveClicked
	onMediaImportComplete:onMediaImportComplete
	onQuestionImportComplete:onQuestionImportComplete
	onSaveComplete:onSaveComplete