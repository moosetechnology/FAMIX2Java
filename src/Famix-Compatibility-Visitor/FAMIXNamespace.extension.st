Extension { #name : #FAMIXNamespace }

{ #category : #'*Famix-Compatibility-Visitor-generated' }
FAMIXNamespace >> accept: aFAMIXVisitor [
	^ aFAMIXVisitor visitNamespace: self
]
