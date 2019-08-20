Extension { #name : #FAMIXDereferencedInvocation }

{ #category : #'*Famix-Compatibility-Visitor-generated' }
FAMIXDereferencedInvocation >> accept: aFAMIXVisitor [
	^ aFAMIXVisitor visitDereferencedInvocation: self
]
