Extension { #name : #FAMIXPreprocessorDefine }

{ #category : #'*Famix-Compatibility-Visitor-generated' }
FAMIXPreprocessorDefine >> accept: aFAMIXVisitor [
	^ aFAMIXVisitor visitPreprocessorDefine: self
]
