"
Allows the Famix2JavaVisitor to filter a set out the methods that are not into a set of selected FamixJavaMethod

	visitor := FAMIX2JavaFiltered new.
	visitor selectedMethods: {aFamixJavaMethod}. 
	visitor endOfLine: String cr.
	visitor exportFolder: 'exportPath/' asFileReference.
	visitor rootFolder: 'exportPath/' asFileReference.
	
	visitor export: MooseModel root at: 1.
"
Class {
	#name : #FAMIX2JavaFiltered,
	#superclass : #FAMIX2JavaVisitor,
	#instVars : [
		'selectedMethods'
	],
	#category : #Famix2Java
}

{ #category : #accessing }
FAMIX2JavaFiltered >> selectedMethods: anObject [

	selectedMethods := anObject
]

{ #category : #transform }
FAMIX2JavaFiltered >> transformAsMock: aMethod [ 
	|class|
	
	aMethod isStub ifTrue: [ ^ self ].
	"Printing method annotations"
	self printMethodAnnotations: aMethod.
	"Printing modifiers of method ex: static,public/private/protected"
	"aMethod modifiers
		do: [ :modifier | 
			self
				<< modifier;
				space ]."
	self indent.
	self <<< (self printVisibility: aMethod).
	aMethod isClassSide ifTrue: [ self <<< 'static ' ].
	"Printing return type for method"
	aMethod declaredType ifNotNil: [ :declaredType | 
		self printDeclaredType: declaredType.
		currentStream << String space ].
	"Printing name + parameters of method"
	(aMethod name = '<Initializer>' or: [ 
		 aMethod isAnInitializer and: [ aMethod isConstructor not ] ])
		ifFalse: [ 
			self
				<<< aMethod name;
				<<< '('.
			(aMethod parameters sorted: [ :p :p2 | 
				 p sourceAnchor startPos < p2 sourceAnchor startPos ])
				do: [ :parameter | parameter accept: self clone  ]
				separatedBy: [ self <<< ', ' ].
			self <<< ')' ]
		ifTrue: [ self << 'static' ].
	"print exception"
	((aMethod withMethodsOverriding collect: [ :m | 
		  m thrownExceptions , m declaredExceptions ])
		 flattened asSet asOrderedCollection sorted: #name ascending) 
		ifNotEmpty: [ :exceptions | 
			self <<< ' throws '.
			exceptions
				do: [ :exception | self <<< exception name ]
				separatedBy: [ self <<< ', ' ] ].


	class := (aMethod atScope: FamixTClass).
	"Printing body of method if class is not abstract or an interface"
	((class ifEmpty: [ true ] ifNotEmpty: [ class anyOne isInterface  ] ) or: [ 
		 aMethod isAbstract isNotNil and: [ aMethod isAbstract ] ])
		ifTrue: [ self <<< ';' ]
		ifFalse: [ 
			currentStream << ' {'.
			self eol.
			self << '//moked method'.
			self eol.
			
			aMethod declaredType ifNotNil: [ :declaredType | 
				aMethod isVoid ifFalse: [ self << 'return null;' ].
				
			 ].
			self
				eol;
				<< '}' ]
]

{ #category : #visiting }
FAMIX2JavaFiltered >> visitMethod: aMethod [
	
	(selectedMethods includes: aMethod) ifTrue: [ 
		super visitMethod: aMethod ]
	ifFalse:[
		self transformAsMock: aMethod.
		].
	
]
