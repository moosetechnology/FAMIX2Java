Extension { #name : #FAMIXType }

{ #category : #'*Famix2Java' }
FAMIXType >> fullNamePrintOn: aStream [
	| parent |
	parent := self container.
	parent
		ifNotNil: [ 	parent fullNamePrintOn: aStream.
				aStream nextPutAll: '.' ].
	self name ifNotNil: [ aStream nextPutAll: self name ].
]
