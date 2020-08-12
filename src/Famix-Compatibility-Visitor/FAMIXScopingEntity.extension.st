Extension { #name : #FAMIXScopingEntity }

{ #category : #'*Famix-Compatibility-Visitor-generated' }
FAMIXScopingEntity >> accept: aFAMIXVisitor [
	^ aFAMIXVisitor visitScopingEntity: self
]
