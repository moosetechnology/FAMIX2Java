Extension { #name : #FAMIXTrait }

{ #category : #'*Famix-Compatibility-Visitor-generated' }
FAMIXTrait >> accept: aFAMIXVisitor [
	^ aFAMIXVisitor visitTrait: self
]
