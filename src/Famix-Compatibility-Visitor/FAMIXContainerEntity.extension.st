Extension { #name : #FAMIXContainerEntity }

{ #category : #'*Famix-Compatibility-Visitor-generated' }
FAMIXContainerEntity >> accept: aFAMIXVisitor [
	^ aFAMIXVisitor visitContainerEntity: self
]
