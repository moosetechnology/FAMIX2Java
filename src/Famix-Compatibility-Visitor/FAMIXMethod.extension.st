Extension { #name : #FAMIXMethod }

{ #category : #'*Famix-Compatibility-Visitor-generated' }
FAMIXMethod >> accept: aFAMIXVisitor [
	^ aFAMIXVisitor visitMethod: self
]
