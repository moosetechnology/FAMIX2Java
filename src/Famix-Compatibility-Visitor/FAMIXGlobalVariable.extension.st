Extension { #name : #FAMIXGlobalVariable }

{ #category : #'*Famix-Compatibility-Visitor-generated' }
FAMIXGlobalVariable >> accept: aFAMIXVisitor [
	^ aFAMIXVisitor visitGlobalVariable: self
]
