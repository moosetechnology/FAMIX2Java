Extension { #name : #FAMIXException }

{ #category : #'*Famix-Compatibility-Visitor-generated' }
FAMIXException >> accept: aFAMIXVisitor [
	^ aFAMIXVisitor visitException: self
]
