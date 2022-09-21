"
A FAMIX2JavaVisitorTest is a test class for testing the behavior of FAMIX2JavaVisitor
"
Class {
	#name : #FAMIX2JavaVisitorTest,
	#superclass : #TestCase,
	#instVars : [
		'visitor'
	],
	#category : #'Famix2Java-Tests'
}

{ #category : #test }
FAMIX2JavaVisitorTest >> setUp [ 
	super setUp.
	visitor := FAMIX2JavaVisitor new.
	visitor endOfLine: String cr
]

{ #category : #test }
FAMIX2JavaVisitorTest >> testVisitMethod [

	| method methodClass exception exceptionClass model resultString |
	model := FamixJavaModel new.
	exception := FamixJavaDeclaredException new.
	exceptionClass := FamixJavaClass new
		                  name: 'MyException';
		                  yourself.
	exception exceptionClass: exceptionClass.
	method := FamixJavaMethod new.
	method name: 'aMethod'.
	method addDeclaredException: exception.

	methodClass := FamixJavaClass new.
	methodClass addMethod: method.
	model addAll: { 
			exception.
			exceptionClass.
			method.
			methodClass }.
	resultString := String streamContents: [ :stream | 
		visitor currentStream: stream.
		method accept: visitor ].
	self assert: resultString equals: 'aMethod() throws MyException {

}'
]
