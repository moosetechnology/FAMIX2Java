Extension { #name : #FAMIXStructuralEntity }

{ #category : #'*Famix-Compatibility-Visitor-generated' }
FAMIXStructuralEntity >> accept: aFAMIXVisitor [
	^ aFAMIXVisitor visitStructuralEntity: self
]
