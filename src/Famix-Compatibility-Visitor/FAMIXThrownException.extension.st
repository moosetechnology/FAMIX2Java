Extension { #name : #FAMIXThrownException }

{ #category : #'*Famix-Compatibility-Visitor-generated' }
FAMIXThrownException >> accept: aFAMIXVisitor [
	^ aFAMIXVisitor visitThrownException: self
]
