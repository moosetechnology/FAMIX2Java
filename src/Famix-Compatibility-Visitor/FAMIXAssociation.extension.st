Extension { #name : #FAMIXAssociation }

{ #category : #'*Famix-Compatibility-Visitor-generated' }
FAMIXAssociation >> accept: aFAMIXVisitor [
	^ aFAMIXVisitor visitAssociation: self
]
