Extension { #name : #FAMIXFile }

{ #category : #'*Famix-Compatibility-Visitor-generated' }
FAMIXFile >> accept: aFAMIXVisitor [
	^ aFAMIXVisitor visitFile: self
]
