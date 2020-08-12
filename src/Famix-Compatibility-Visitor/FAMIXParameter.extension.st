Extension { #name : #FAMIXParameter }

{ #category : #'*Famix-Compatibility-Visitor-generated' }
FAMIXParameter >> accept: aFAMIXVisitor [
	^ aFAMIXVisitor visitParameter: self
]
