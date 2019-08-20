Extension { #name : #FAMIXEnum }

{ #category : #'*Famix-Compatibility-Visitor-generated' }
FAMIXEnum >> accept: aFAMIXVisitor [
	^ aFAMIXVisitor visitEnum: self
]
