Extension { #name : #FAMIXPrimitiveType }

{ #category : #'*Famix-Compatibility-Visitor-generated' }
FAMIXPrimitiveType >> accept: aFAMIXVisitor [
	^ aFAMIXVisitor visitPrimitiveType: self
]
