Extension { #name : #FAMIXCSourceLanguage }

{ #category : #'*Famix-Compatibility-Visitor-generated' }
FAMIXCSourceLanguage >> accept: aFAMIXVisitor [
	^ aFAMIXVisitor visitCSourceLanguage: self
]
