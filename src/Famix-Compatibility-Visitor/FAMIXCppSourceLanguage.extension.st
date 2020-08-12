Extension { #name : #FAMIXCppSourceLanguage }

{ #category : #'*Famix-Compatibility-Visitor-generated' }
FAMIXCppSourceLanguage >> accept: aFAMIXVisitor [
	^ aFAMIXVisitor visitCppSourceLanguage: self
]
