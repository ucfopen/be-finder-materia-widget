befinder = angular.module 'befinder', ['ngSanitize']

befinder.controller "befinderCtrl", ['$scope', ($scope) ->

	$scope.input = ''
	$scope.output = ''

	$scope.findText = ->

		replacer = (string, p1, n, s) ->
			return '<span class="bee">'+string+'</span>'

		replaced = $scope.input.replace /\b(am|is|are|was|were|be|being|been)\b/gi, replacer
		$scope.output = replaced


	$scope.resetText = ->
		$scope.input = ''
		$scope.output = ''
]