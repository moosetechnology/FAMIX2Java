Extension { #name : #FAMIXUnknownVariable }

{ #category : #'*Famix-Compatibility-Visitor-generated' }
FAMIXUnknownVariable >> accept: aFAMIXVisitor [
	^ aFAMIXVisitor visitUnknownVariable: self
]
