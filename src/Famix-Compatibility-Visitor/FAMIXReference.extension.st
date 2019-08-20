Extension { #name : #FAMIXReference }

{ #category : #'*Famix-Compatibility-Visitor-generated' }
FAMIXReference >> accept: aFAMIXVisitor [
	^ aFAMIXVisitor visitReference: self
]
