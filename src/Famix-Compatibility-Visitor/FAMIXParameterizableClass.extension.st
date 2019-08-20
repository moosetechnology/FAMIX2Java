Extension { #name : #FAMIXParameterizableClass }

{ #category : #'*Famix-Compatibility-Visitor-generated' }
FAMIXParameterizableClass >> accept: aFAMIXVisitor [
	^ aFAMIXVisitor visitParameterizableClass: self
]
