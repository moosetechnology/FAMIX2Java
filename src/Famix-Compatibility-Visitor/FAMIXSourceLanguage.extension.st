Extension { #name : #FAMIXSourceLanguage }

{ #category : #'*Famix-Compatibility-Visitor-generated' }
FAMIXSourceLanguage >> accept: aFAMIXVisitor [
	^ aFAMIXVisitor visitSourceLanguage: self
]
