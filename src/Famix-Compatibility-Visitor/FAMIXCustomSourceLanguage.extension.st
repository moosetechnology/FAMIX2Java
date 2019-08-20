Extension { #name : #FAMIXCustomSourceLanguage }

{ #category : #'*Famix-Compatibility-Visitor-generated' }
FAMIXCustomSourceLanguage >> accept: aFAMIXVisitor [
	^ aFAMIXVisitor visitCustomSourceLanguage: self
]
