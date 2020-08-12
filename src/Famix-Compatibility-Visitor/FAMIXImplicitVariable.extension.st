Extension { #name : #FAMIXImplicitVariable }

{ #category : #'*Famix-Compatibility-Visitor-generated' }
FAMIXImplicitVariable >> accept: aFAMIXVisitor [
	^ aFAMIXVisitor visitImplicitVariable: self
]
