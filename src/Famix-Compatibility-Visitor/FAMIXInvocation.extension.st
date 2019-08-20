Extension { #name : #FAMIXInvocation }

{ #category : #'*Famix-Compatibility-Visitor-generated' }
FAMIXInvocation >> accept: aFAMIXVisitor [
	^ aFAMIXVisitor visitInvocation: self
]
