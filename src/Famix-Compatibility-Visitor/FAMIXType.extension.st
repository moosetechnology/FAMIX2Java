Extension { #name : #FAMIXType }

{ #category : #'*Famix-Compatibility-Visitor-generated' }
FAMIXType >> accept: aFAMIXVisitor [
	^ aFAMIXVisitor visitType: self
]
