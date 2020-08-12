Extension { #name : #FAMIXSourcedEntity }

{ #category : #'*Famix-Compatibility-Visitor-generated' }
FAMIXSourcedEntity >> accept: aFAMIXVisitor [
	^ aFAMIXVisitor visitSourcedEntity: self
]
