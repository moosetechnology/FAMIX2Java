Extension { #name : #FAMIXDeclaredException }

{ #category : #'*Famix-Compatibility-Visitor-generated' }
FAMIXDeclaredException >> accept: aFAMIXVisitor [
	^ aFAMIXVisitor visitDeclaredException: self
]
