Extension { #name : #FAMIXParameterizedType }

{ #category : #'*Famix-Compatibility-Visitor-generated' }
FAMIXParameterizedType >> accept: aFAMIXVisitor [
	^ aFAMIXVisitor visitParameterizedType: self
]
