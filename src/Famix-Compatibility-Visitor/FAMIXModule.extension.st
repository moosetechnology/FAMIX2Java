Extension { #name : #FAMIXModule }

{ #category : #'*Famix-Compatibility-Visitor-generated' }
FAMIXModule >> accept: aFAMIXVisitor [
	^ aFAMIXVisitor visitModule: self
]
