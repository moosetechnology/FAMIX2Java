Extension { #name : #FAMIXNamedEntity }

{ #category : #'*Famix-Compatibility-Visitor-generated' }
FAMIXNamedEntity >> accept: aFAMIXVisitor [
	^ aFAMIXVisitor visitNamedEntity: self
]
