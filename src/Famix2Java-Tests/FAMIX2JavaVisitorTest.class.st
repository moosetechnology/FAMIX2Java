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
