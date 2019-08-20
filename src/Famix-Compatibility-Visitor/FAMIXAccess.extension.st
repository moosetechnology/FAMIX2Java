Extension { #name : #FAMIXAccess }

{ #category : #'*Famix-Compatibility-Visitor-generated' }
FAMIXAccess >> accept: aFAMIXVisitor [
	^ aFAMIXVisitor visitAccess: self
]
