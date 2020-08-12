Extension { #name : #FAMIXInclude }

{ #category : #'*Famix-Compatibility-Visitor-generated' }
FAMIXInclude >> accept: aFAMIXVisitor [
	^ aFAMIXVisitor visitInclude: self
]
