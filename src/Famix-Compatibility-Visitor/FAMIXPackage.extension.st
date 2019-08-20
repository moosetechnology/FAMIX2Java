Extension { #name : #FAMIXPackage }

{ #category : #'*Famix-Compatibility-Visitor-generated' }
FAMIXPackage >> accept: aFAMIXVisitor [
	^ aFAMIXVisitor visitPackage: self
]
