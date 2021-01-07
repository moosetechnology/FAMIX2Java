Extension { #name : #FAMIXNamespace }

{ #category : #'*Famix2Java' }
FAMIXNamespace >> fullNamePrintOn: aStream [
	self belongsTo
		ifNotNil: [ :parent | 
			parent fullNamePrintOn: aStream.
			aStream nextPut: $. ].
	self name ifNotNil: [ aStream nextPutAll: self name ]
]
