Extension { #name : #FAMIXLeafEntity }

{ #category : #'*Famix-Compatibility-Visitor-generated' }
FAMIXLeafEntity >> accept: aFAMIXVisitor [
	^ aFAMIXVisitor visitLeafEntity: self
]
