const befinder = angular.module('befinder', ['ngSanitize'])

befinder.controller("befinderCtrl", ['$scope', ($scope) => {
	$scope.input = ''
	$scope.output = ''

	$scope.findText = () => {
		const replacer = (string, p1, n, s) => `<span class="bee">${string}</span>`
		$scope.output = $scope.input.replace(/\b(am|is|are|was|were|be|being|been)\b/gi, replacer)
	}

	$scope.resetText = () => {
		$scope.input = ''
		$scope.output = ''
	}

}])

console.log('load')
