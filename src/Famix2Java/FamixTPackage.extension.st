Extension { #name : #FamixTPackage }

{ #category : #'*Famix2Java' }
FamixTPackage >> fullNamePrintOn: aStream [
	self belongsTo
		ifNotNil: [ :parent | 
			parent fullNamePrintOn: aStream.
			aStream nextPut: $. ].
	self name ifNotNil: [ aStream nextPutAll: self name ]
]
