app.directive 'inputMatch', ->
    restrict: 'A'
    scope: true
    require: 'ngModel'
    link: (scope, el, attrs, control) ->
      checker = ->
        e1 = scope.$eval(attrs.ngModel)
        e2 = scope.$eval(attrs.inputMatch)
        return e1 == e2
      scope.$watch checker, (n) ->
        control.$setValidity('unique', n)