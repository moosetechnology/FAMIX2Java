Extension { #name : #FAMIXParameterType }

{ #category : #'*Famix-Compatibility-Visitor-generated' }
FAMIXParameterType >> accept: aFAMIXVisitor [
	^ aFAMIXVisitor visitParameterType: self
]
