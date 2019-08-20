Extension { #name : #FAMIXAttribute }

{ #category : #'*Famix-Compatibility-Visitor-generated' }
FAMIXAttribute >> accept: aFAMIXVisitor [
	^ aFAMIXVisitor visitAttribute: self
]
