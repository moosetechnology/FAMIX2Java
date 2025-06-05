Extension { #name : #FamixTType }

{ #category : #'*Famix2Java' }
FamixTType >> fullNamePrintOn: aStream [

	| parent |
	parent := self typeContainer.
	parent ifNotNil: [ 
		parent fullNamePrintOn: aStream.
		aStream nextPutAll: '.' ].
	self name ifNotNil: [ aStream nextPutAll: self name ]
]
