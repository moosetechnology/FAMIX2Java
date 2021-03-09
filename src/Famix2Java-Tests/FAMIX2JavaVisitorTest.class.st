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
	aString := String
		streamContents: [ :stream | 
			visitor currentStream: stream.
			visitor visitAnnotationInstance: aInst ].
	self assert: aString equals: '@Banana'
]

{ #category : #test }
FAMIX2JavaVisitorTest >> testVisitAnnotationInstanceAttribute [
	"
	@Banana(Banane = Apple)
	myMethod(){
	}
	"
	| aInstAttribute aNameString aTypeAttribute |
	aInstAttribute := FAMIXAnnotationInstanceAttribute new.
	aTypeAttribute := FAMIXAnnotationTypeAttribute new.
	aTypeAttribute name: 'Banana'.
	aInstAttribute annotationTypeAttribute: aTypeAttribute.
	aInstAttribute value: 'Apple'.	"probably not realistic"
	aNameString := String
		streamContents: [ :stream | 
			visitor currentStream: stream.
			visitor visitAnnotationInstanceAttribute: aInstAttribute ].
	self assert: aNameString equals: 'Banana = Apple'
]

{ #category : #test }
FAMIX2JavaVisitorTest >> testVisitParameterizableType [
	"Example: public class Banana<Integer>"

	| aParameterizableType aNameString argument1 argument2 |
	aParameterizableType := FAMIXParameterizableClass new.
	aParameterizableType name: 'Banana'.
	aNameString := String
		streamContents: [ :stream | 
			visitor currentStream: stream.
			visitor visitParameterizedType: aParameterizableType ].
	self assert: aNameString equals: 'Banana<>'.

	"Example: public class Orange<Integer,String>"
	aParameterizableType := FAMIXParameterizableClass new.
	aParameterizableType name: 'Orange'.
	argument1 := FAMIXClass new.
	argument1 name: 'Integer'.
	argument2 := FAMIXClass new.
	argument2 name: 'String'.
	aParameterizableType
		arguments:
			{argument1.
			argument2}.
	aNameString := String
		streamContents: [ :stream | 
			visitor currentStream: stream.
			visitor visitParameterizableType: aParameterizableType ].
	self assert: aNameString equals: 'Orange<Integer,String>'
]

{ #category : #test }
FAMIX2JavaVisitorTest >> testVisitParameterizedType [
	"Example: public class Banana<>"

	| aParameterizedType aNameString argument1 argument2 |

	self fail. "I'm not sure of this test at all"
	aParameterizedType := FAMIXParameterizedType new.
	aParameterizedType name: 'Banana'.
	aNameString := String
		streamContents: [ :stream | 
			visitor currentStream: stream.
			visitor visitParameterizedType: aParameterizedType ].
	self assert: aNameString equals: 'Banana<>'.

	"Example: public class Orange<T,U>"
	aParameterizedType := FAMIXParameterizedType new.
	aParameterizedType name: 'Orange'.
	self
		flag:
			'Not sure what type are the arguments in this test - probably not FAMIXClass if I look at https://docs.oracle.com/javase/tutorial/java/generics/types.html'.
	argument1 := FAMIXClass new.
	argument1 name: 'T'.
	argument2 := FAMIXClass new.
	argument2 name: 'U'.
	aParameterizedType
		arguments:
			{argument1.
			argument2}.
	aNameString := String
		streamContents: [ :stream | 
			visitor currentStream: stream.
			visitor visitParameterizedType: aParameterizedType ].
	self assert: aNameString equals: 'Orange<T,U>'
]
