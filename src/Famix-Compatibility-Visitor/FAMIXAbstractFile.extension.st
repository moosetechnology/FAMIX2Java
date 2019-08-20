Extension { #name : #FAMIXAbstractFile }

{ #category : #'*Famix-Compatibility-Visitor-generated' }
FAMIXAbstractFile >> accept: aFAMIXVisitor [
	^ aFAMIXVisitor visitAbstractFile: self
]
