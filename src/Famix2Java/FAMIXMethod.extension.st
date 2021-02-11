Extension { #name : #FAMIXMethod }

{ #category : #'*Famix2Java' }
FAMIXMethod >> bodySourceText [
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
FAMIXMethod >> withMethodsOverriding [
	^ (self belongsTo subclassHierarchy
		collect: [ :each | each implementationOf: self signature ]
		thenSelect: #isNotNil)
		add: self;
		yourself
]
