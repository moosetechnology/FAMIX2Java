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
				to: (sourceText findLastOccurrenceOfString: '}' startingAt: 0) - 1 ]
		ifEmpty: [ '' ]
]
