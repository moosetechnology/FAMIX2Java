Extension { #name : #FAMIXComment }

{ #category : #'*Famix-Compatibility-Visitor-generated' }
FAMIXComment >> accept: aFAMIXVisitor [
	^ aFAMIXVisitor visitComment: self
]
