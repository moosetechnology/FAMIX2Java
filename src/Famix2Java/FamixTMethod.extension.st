Extension { #name : #FamixTMethod }

{ #category : #'*Famix2Java' }
FamixTMethod >> bodySourceText [
	^ self sourceText
		ifNotEmpty: [ :sourceText | 
			sourceText
				copyFrom:
					(sourceText
						findString: '{'
						startingAt: (self sourceText findString: self name ) )+ 1
				to: (sourceText findLastOccurrenceOfString: '}' startingAt: 1) - 1 ]
		ifEmpty: [ '' ]
]

{ #category : #'*Famix2Java' }
FamixTMethod >> isAnInitializer [

	^ ((self mooseModel respondsTo: #isSmalltalk) and: [ 
		   self mooseModel isSmalltalk ])
		  ifTrue: [ 
			  (('*initialize*' match: self category) or: [ 
				   '*initialize*' match: self name ]) or: [ self isConstructor ] ]
		  ifFalse: [ self name = '<Initializer>' or: [ self isConstructor ] ]
]

{ #category : #'*Famix2Java' }
FamixTMethod >> withMethodsOverriding [

	^ (self belongsTo subclassHierarchy
		   collect: [ :each | each implementationOf: self signature ]
		   thenSelect: #isNotNil)
		  add: self;
		  yourself
]
