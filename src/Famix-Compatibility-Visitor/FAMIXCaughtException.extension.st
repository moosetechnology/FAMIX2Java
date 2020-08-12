Extension { #name : #FAMIXCaughtException }

{ #category : #'*Famix-Compatibility-Visitor-generated' }
FAMIXCaughtException >> accept: aFAMIXVisitor [
	^ aFAMIXVisitor visitCaughtException: self
]
