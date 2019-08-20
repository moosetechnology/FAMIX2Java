Extension { #name : #FAMIXClass }

{ #category : #'*Famix-Compatibility-Visitor-generated' }
FAMIXClass >> accept: aFAMIXVisitor [
	^ aFAMIXVisitor visitClass: self
]
