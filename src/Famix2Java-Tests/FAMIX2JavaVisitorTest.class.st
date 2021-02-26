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

{ #category : #running }
FAMIX2JavaVisitorTest >> setUp [
	"Hooks that subclasses may override to define the fixture of test."
	super setUp.
	visitor := FAMIX2JavaVisitor new
]

{ #category : #test }
FAMIX2JavaVisitorTest >> testVisitAnnotationInstance [

	| aInst aType aString |
	aInst := FAMIXAnnotationInstance new. 
	aType := FAMIXAnnotationType new.
	aType name: 'Banana'.
	aInst annotationType: aType.
	
	aString := String streamContents: [ :stream | visitor currentStream: stream. visitor visitAnnotationInstance: aInst].
	self assert: aString equals: '@Banana'.

]
