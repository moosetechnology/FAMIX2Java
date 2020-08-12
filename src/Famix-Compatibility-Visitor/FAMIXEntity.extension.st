Extension { #name : #FAMIXEntity }

{ #category : #'*Famix-Compatibility-Visitor-generated' }
FAMIXEntity >> accept: aFAMIXVisitor [
	^ aFAMIXVisitor visitEntity: self
]
