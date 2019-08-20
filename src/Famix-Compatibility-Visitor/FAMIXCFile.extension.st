Extension { #name : #FAMIXCFile }

{ #category : #'*Famix-Compatibility-Visitor-generated' }
FAMIXCFile >> accept: aFAMIXVisitor [
	^ aFAMIXVisitor visitCFile: self
]
