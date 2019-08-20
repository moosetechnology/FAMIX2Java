Extension { #name : #FAMIXFolder }

{ #category : #'*Famix-Compatibility-Visitor-generated' }
FAMIXFolder >> accept: aFAMIXVisitor [
	^ aFAMIXVisitor visitFolder: self
]
