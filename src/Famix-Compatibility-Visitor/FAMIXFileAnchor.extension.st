Extension { #name : #FAMIXFileAnchor }

{ #category : #'*Famix-Compatibility-Visitor-generated' }
FAMIXFileAnchor >> accept: aFAMIXVisitor [
	^ aFAMIXVisitor visitFileAnchor: self
]
