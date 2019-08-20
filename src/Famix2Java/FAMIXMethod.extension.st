Extension { #name : #FAMIXMethod }

{ #category : #'*Famix2Java' }
FAMIXMethod >> bodySourceText [
	^ (self sourceText copyFrom: (self sourceText findString: '{') + 1 to: (self sourceText findLastOccurrenceOfString: '}' startingAt: 0) - 1) trimBoth
]
