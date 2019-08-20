Extension { #name : #FAMIXFunction }

{ #category : #'*Famix-Compatibility-Visitor-generated' }
FAMIXFunction >> accept: aFAMIXVisitor [
	^ aFAMIXVisitor visitFunction: self
]
