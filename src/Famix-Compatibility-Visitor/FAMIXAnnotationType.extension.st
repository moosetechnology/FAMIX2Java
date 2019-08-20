Extension { #name : #FAMIXAnnotationType }

{ #category : #'*Famix-Compatibility-Visitor-generated' }
FAMIXAnnotationType >> accept: aFAMIXVisitor [
	^ aFAMIXVisitor visitAnnotationType: self
]
