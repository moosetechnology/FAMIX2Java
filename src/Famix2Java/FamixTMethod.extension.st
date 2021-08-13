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
