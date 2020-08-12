Extension { #name : #FAMIXTypeAlias }

{ #category : #'*Famix-Compatibility-Visitor-generated' }
FAMIXTypeAlias >> accept: aFAMIXVisitor [
	^ aFAMIXVisitor visitTypeAlias: self
]
