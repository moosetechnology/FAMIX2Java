Extension { #name : #FAMIXPreprocessorStatement }

{ #category : #'*Famix-Compatibility-Visitor-generated' }
FAMIXPreprocessorStatement >> accept: aFAMIXVisitor [
	^ aFAMIXVisitor visitPreprocessorStatement: self
]
