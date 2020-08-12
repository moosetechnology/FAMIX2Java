Extension { #name : #FAMIXCompilationUnit }

{ #category : #'*Famix-Compatibility-Visitor-generated' }
FAMIXCompilationUnit >> accept: aFAMIXVisitor [
	^ aFAMIXVisitor visitCompilationUnit: self
]
