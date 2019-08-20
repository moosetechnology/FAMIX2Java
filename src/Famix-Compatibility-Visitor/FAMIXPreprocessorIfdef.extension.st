Extension { #name : #FAMIXPreprocessorIfdef }

{ #category : #'*Famix-Compatibility-Visitor-generated' }
FAMIXPreprocessorIfdef >> accept: aFAMIXVisitor [
	^ aFAMIXVisitor visitPreprocessorIfdef: self
]
