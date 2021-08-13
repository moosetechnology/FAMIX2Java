Extension { #name : #FamixTNamespace }

{ #category : #'*Famix2Java' }
FamixTNamespace >> fullNamePrintOn: aStream [
	self belongsTo
		ifNotNil: [ :parent | 
			parent fullNamePrintOn: aStream.
			aStream nextPut: $. ].
	self name ifNotNil: [ aStream nextPutAll: self name ]
]
