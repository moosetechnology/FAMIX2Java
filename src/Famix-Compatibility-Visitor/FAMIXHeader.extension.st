Extension { #name : #FAMIXHeader }

{ #category : #'*Famix-Compatibility-Visitor-generated' }
FAMIXHeader >> accept: aFAMIXVisitor [
	^ aFAMIXVisitor visitHeader: self
]
