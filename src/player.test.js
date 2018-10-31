describe('Player Controller', function() {
	require('angular/angular.js')
	require('angular-mocks/angular-mocks.js')
	require('angular-sanitize')

	var $controller
	var mockNgSanitize

	beforeEach(() => {
		jest.resetModules()

		angular.mock.module('befinder')

		require('./player.coffee')

		// use angular mock to access angular modules
		inject(function(_$controller_) {
			$controller = _$controller_
		})
	})

	test('befinderCtrl defines expected properties and methods', () => {
		var $scope = {}
		var controller = $controller('befinderCtrl', { $scope })

		expect($scope).toHaveProperty('input', '')
		expect($scope).toHaveProperty('output', '')
		expect($scope).toHaveProperty('findText', expect.any(Function))
		expect($scope).toHaveProperty('resetText', expect.any(Function))
	})

	test('resetText resets input and output', () => {
		var $scope = {}
		var controller = $controller('befinderCtrl', { $scope })

		$scope.input = 'input'
		$scope.output = 'output'

		expect($scope.input).toBe('input')
		expect($scope.output).toBe('output')

		$scope.resetText()

		expect($scope.input).toBe('')
		expect($scope.output).toBe('')
	})
	//'<span class="bee">'+string+'</span>'

	test('findText highlights words correctly', () => {
		var $scope = {}
		var controller = $controller('befinderCtrl', { $scope })

		//first test - should not highlight a phrase not containing keywords
		$scope.input = 'input phrase has no keywords'
		$scope.findText()
		$scope.output = 'input phrase has no keywords'

		//second test - should highlight keywords in a phrase
		$scope.input = 'keyword in phrase is highlighted'
		$scope.findText()
		$scope.input = 'keyword in phrase <span class="bee">is</span> highlighted'
	})
})
