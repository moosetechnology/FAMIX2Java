Extension { #name : #FAMIXJavaSourceLanguage }

{ #category : #'*Famix-Compatibility-Visitor-generated' }
FAMIXJavaSourceLanguage >> accept: aFAMIXVisitor [
	^ aFAMIXVisitor visitJavaSourceLanguage: self
]
