Extension { #name : #FAMIXLocalVariable }

{ #category : #'*Famix-Compatibility-Visitor-generated' }
FAMIXLocalVariable >> accept: aFAMIXVisitor [
	^ aFAMIXVisitor visitLocalVariable: self
]
